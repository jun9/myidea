Myidea::Application.routes.draw do
  root :to => "ideas#index"
  match "login" => "users#login"
  get 'logout' => "users#logout"
  get 'dashboard' => "ideas#dashboard"
  resources :ideas do
    match 'tab',:on => :collection
    match 'promotion',:on => :collection
    match 'like',:on => :member
    match 'unlike',:on => :member
    get "search",:on => :collection
    resources :comments,:shallow => :true
  end
  resources :users
  resources :categories
end
