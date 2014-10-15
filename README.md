
### Generate Mailer
```
$ rails g mailer VisitorMailer
```

### add letter_opener and launchy gem

This will allow us to, instead of sending an email in development (messy), to open the email in a browser window.

```
gem "letter_opener"
gem "launchy"
```

We need to modify the config dev environment for it to work.

```
# to be appraised of mailing errors
config.action_mailer.raise_delivery_errors = true
# to deliver to the browser instead of email
config.action_mailer.delivery_method = :letter_opener
```

### Create action

Just like a controller. We pass it the info to mail, and we make it available to the view (email template) through instance variables.

We would take out the email address later on and set it in an ENV variable for production.

```
class VisitorMailer < ActionMailer::Base
  default from: "from@example.com"

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: 'javier@badaboom.com', subject: subject: 'New Visitor\'s Email')
  end
end
```

### Create the views

In html and text format (only shown html) with info passed through instance variables from the VisitorMailer.

```
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1><%= @name %> (<%= @email %>)</h1>
    <p>
      <%= @message %>
    </p>
  </body>
</html>
```

They access the instance variables defined in the mailer action

### Generate Controler

```
$ rails g controller visitors
```

The index actions displays the basic contact form, which is submitted to the contact action. Here we extract the form parameters and create a JSON hash that we pass to the worker,
```
class VisitorsController < ApplicationController
  def index
  end

  def contact
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    h = JSON.generate({ 'name' => @name, 'email' => @email, 'message' => @message})
    PostmanWorker.perform_async(h, 5)

    redirect_to :root
  end
end
```

### Update the routes

```
Rails.application.routes.draw do
  post 'visitors/contact', to: 'visitors#contact'
  root 'visitors#index'
end
```

### The background worker

We follow instructions from Sidekiq's readme. The key here is that the worker needs a json object as simple as possible. Usually this would be the id from a Model object, and Sidekiq would serialize and deserialize.

In our case, the information is not stored in the database so we create a json hash, that we passed the worker for queueing in Redis. Now we de-serialize upon arrival to re-create the hash so we can finally call the ActionMailer to deliver the email.

```
class PostmanWorker
  include Sidekiq::Worker

  def perform(h, count)
    h = JSON.load(h)
    VisitorMailer.contact_email(h['name'], h['email'], h['message']).deliver
  end
end
```

------------------------------------------------------------

### Add Dashboard

The Sidekiq dashboard uses Sinatra, which we have to add to the Gemfile.

```
gem 'sinatra', '>= 1.3.0', :require => nil
```

Add to config routes.

```
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```

### Install redis (if not installed yet)

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
