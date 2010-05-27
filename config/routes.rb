ActionController::Routing::Routes.draw do |map|
  map.dashboard 'dashboard', :controller => 'dashboard'
  
  map.resources :brands do |brand|
    brand.resources :queries, :only => [:create, :update, :destroy]
  end
  map.resources :brand_results, 
    :only => [:index, :show],
    :member => { :positive => :put, :neutral => :put, :negative => :put, :follow_up => :put, :reject => :put, :finish => :put, :mark_as_read => :put },
    :collection => { :mark_all_as_read => :post } do |brand_result|
    brand_result.resources :comments, :only => [:create]
  end
  
  #user and account related routes
  map.resource :team, :only => [:show] do |team|
    team.resources :users, :only => [:new, :create, :destroy], :member => { :alter_status => :post }
  end
  map.resource :user_info, :controller => "users", :only => [:edit, :update]
  map.resource :user_session
  map.resource :account do |account|
    account.resources :subscriptions, :only => [:update]
  end
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :user_signups, :only => [:edit, :update]

  map.with_options(:controller => 'pages', :action => 'show') do |pages|
    pages.connect '/about', :id => 'about'
    pages.connect '/pages/:id'
  end
  
  map.root :controller => "dashboard"
end
