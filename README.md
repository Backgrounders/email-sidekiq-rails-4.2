
### Generate Mailer
```
rails g mailer VisitorMailer
```

### Create action

Just like a controller.

```
class VisitorMailer < ActionMailer::Base
  default from: "from@example.com"

  def contact_email(visitor)
    @visitor = visitor

    mail(to: visitor.email, subject: 'xxx')
  end
end
```

### Create the views (html and text)

They access the instance variables defined in the mailer action
