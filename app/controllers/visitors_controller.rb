class VisitorsController < ApplicationController
  def index
  end

  def contact
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    h = JSON.generate({ 'name' => @name, 'email' => @email, 'message' => @message})
    PostmanWorker.perform_async(h, 5)

    # if instead of sidekiq I was just sending email from rails
    # VisitorMailer.contact_email(@name, @email, @message).deliver

    redirect_to :root
  end
end
