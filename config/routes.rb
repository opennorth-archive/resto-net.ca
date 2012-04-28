RestoNet::Application.routes.draw do
  filter :locale

  match '/', to: 'pages#city', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }

  resources :establishments, :only => [:index, :show]

  match 'channel', to: 'pages#channel'
  match 'about', to: 'pages#about'
  match 'api', to: 'pages#api'
  match 'request', to: 'pages#request'

  root to: 'pages#index'

end
