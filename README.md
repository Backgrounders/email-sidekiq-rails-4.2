
### Generate Mailer
```
$ rails g mailer VisitorMailer
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

### Generate Controlers

```
$ rails g controller visitors
------------------------------
class VisitorsController < ApplicationController
  def index
  end
end
```

### Update the routes

```
Rails.application.routes.draw do
  root 'visitors#index'
end
```

### add letter_opener and launchy gem
```
gem "letter_opener"
gem "launchy"
```

### modify the config dev environment

```
# to be appraised of mailing errors
config.action_mailer.raise_delivery_errors = true
# to deliver to the browser instead of email
config.action_mailer.delivery_method = :letter_opener
```

------------------------------------------------------------

### Add Dashboard

The Sidekiq dashboard uses Sinatra, which we have to add to the Gemfile

```
gem 'sinatra', '>= 1.3.0', :require => nil
```

Add to config routes
```
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```

### Install redis (if not there yet)
```
$ brew install redis
```

------------------------------------------------------------
### Start rails
```
$ rails s
```

### Start redis
```
$ redis-server
```

### Start Sidekiq
```
$ bundle exec sidekiq
```
