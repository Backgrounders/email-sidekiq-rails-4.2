class VisitorMailer < ActionMailer::Base
  default from: "from@example.com"

  def contact_email(visitor)
    @visitor = visitor

    mail(to: visitor.email, subject: 'xxx')
  end
end
