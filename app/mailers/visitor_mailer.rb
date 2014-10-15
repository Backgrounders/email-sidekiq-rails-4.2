class VisitorMailer < ActionMailer::Base
  default from: "from@example.com"

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: 'fjs6@yahoo.com', subject: @message)
  end
end
