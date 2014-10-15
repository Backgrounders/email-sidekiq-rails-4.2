class VisitorMailer < ActionMailer::Base
  default from: "from@example.com"

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: 'javier@badaboom.com', subject: subject: 'New Visitor\'s Email')
  end
end
