RestoNet::Application.routes.draw do
  filter :locale

  match '/:locale', to: 'pages#home', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }

  root to: 'pages#home'

  resources :establishments, :only => [:index, :show]

  match 'about', to: 'pages#about'
  match 'api', to: 'pages#api'

end
