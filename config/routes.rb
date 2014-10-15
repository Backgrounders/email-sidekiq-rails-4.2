Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'visitors/contact', to: 'visitors#contact'
  root 'visitors#index'
end
