Myidea::Application.routes.draw do
  root :to => "ideas#index"
  match "login" => "users#login"
  get 'logout' => "users#logout"
  get 'dashboard' => "ideas#dashboard"
  resources :ideas do
    match 'tab',:on => :collection
    match 'promotion',:on => :collection
    match 'preview',:on => :collection
    match 'like',:on => :member
    match 'unlike',:on => :member
    match 'handle',:on => :member
    match 'search',:on => :collection
    match 'favoriate',:on => :member
    match 'unfavoriate',:on => :member
    resources :comments,:shallow => :true
  end
  resources :users do
    get 'activity',:on => :member
    get 'act',:on => :member
    put 'authority',:on => :member
  end
  resources :categories
end
