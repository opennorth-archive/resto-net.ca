Restonet::Application.routes.draw do
  filter :locale

  resources :establishments, :only => [:index, :show]

  match 'about' => 'pages#about'
  match 'api' => 'pages#api'

  root :to => 'pages#home'

end
