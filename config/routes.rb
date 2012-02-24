RestoNet::Application.routes.draw do
  filter :locale

  match '/', to: 'establishments#index', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }

  resources :establishments, :only => [:index, :show]

  match 'channel', to: 'pages#channel'
  match 'about', to: 'pages#about'
  match 'api', to: 'pages#api'

  root to: 'pages#index'

end
