Myidea::Application.routes.draw do
  devise_for :users
  root :to => "ideas#index"
  resources :topics
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
    resources :solutions,:shallow => :true
  end
  resources :users do
    get 'activity',:on => :member
    get 'act',:on => :member
    put 'authority',:on => :member
  end
  resources :preferences do
    get 'dashboard',:on => :collection
  end
end
