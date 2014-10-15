class PostmanWorker
  include Sidekiq::Worker

  def perform(h, count)
    h = JSON.load(h)
    VisitorMailer.contact_email(h['name'], h['email'], h['message']).deliver
  end
end
