class VisitorsController < ApplicationController
  def index
  end

  def contact
    h = JSON.generate({ 'name' => params[:name],
                        'email' => params[:email],
                        'message' => params[:message] })

    PostmanWorker.perform_async(h, 5)

    # I would use thi sif instead of sidekiq I was just sending email from rails
    # VisitorMailer.contact_email(@name, @email, @message).deliver

    redirect_to :root
  end
end
