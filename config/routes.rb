RestoNet::Application.routes.draw do
  require 'subdomain'

  filter :locale

  constraints(Subdomain) do
    #root :to => 'pages#home'
    match '/:locale' => 'pages#home'
  end

  root :to => 'pages#home'

  resources :establishments, :only => [:index, :show]

  match 'about' => 'pages#about'
  match 'api' => 'pages#api'

end
