RestoNet::Application.routes.draw do
  filter :locale

  constraints lambda { |r| r.subdomain.present? && r.subdomain != 'www' } do
    match '/', to: 'pages#city'
    resources :establishments, only: [:index, :show]
    resources :inspections, only: [:index]
  end

  match 'channel', to: 'pages#channel'
  match 'about', to: 'pages#about'
  match 'api', to: 'pages#api'
  match 'request', to: 'pages#request'

  root to: 'pages#index'

end
