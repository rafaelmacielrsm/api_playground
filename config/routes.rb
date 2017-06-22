Rails.application.routes.draw do
  # Api Definition
  namespace :api,
    defaults: { format: :json },
    constraints: { subdomain: 'api' },
    path: '/' do

  end

end
