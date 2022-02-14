Rails.application.routes.draw do
  #API definition
  namespace :api, defaults: {format: :json}, constraints: {subdomain: 'api'} do
    #list of API resource

  end
end
