ActionController::Routing::Routes.draw do |map|
  map.dashboard 'dashboard', :controller => 'dashboard'
  
  map.resources :brands do |brand|
    brand.resources :queries, :only => [:create, :update, :destroy]
  end
  map.resources :brand_results, :only => [:index, :show, :update] do |brand_result|
    brand_result.resources :comments, :only => [:create]
  end
  
  #user and account related routes
  map.resource :team, :only => [:show] do |team|
    team.resources :users, :only => [:new, :create, :destroy], :member => { :alter_status => :post }
  end
  map.resource :user_info, :controller => "users", :only => [:edit, :update]
  map.resource :user_session
  map.resource :account, :except => [:new]
  map.signup '/signup/:invitation_token', :controller => "accounts", :action => "new"
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :user_signups, :only => [:edit, :update]
  map.resources :invitations, :only => [:new, :create]

  map.with_options(:controller => 'pages', :action => 'show') do |pages|
    pages.connect '/about', :id => 'about'
    pages.connect '/pages/:id'
  end
  
  map.root :controller => "dashboard"
end
