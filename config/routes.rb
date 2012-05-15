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
  match 'mapaq_request/:establishment_id' => 'pages#mapaq_request'

  root to: 'pages#index'

end
