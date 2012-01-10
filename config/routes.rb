Restonet::Application.routes.draw do
  filter :locale

  root :to => 'pages#home'

  resources :establishments, :only => [:index, :show]

  match 'establishments/index' => 'establishments#index'
  match 'about' => 'pages#about'
  match 'api' => 'pages#api'

end
