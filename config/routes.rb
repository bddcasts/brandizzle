ActionController::Routing::Routes.draw do |map|
  map.root :controller => "brand_results"
  
  map.resources :brands do |brand|
    brand.resources :queries, :only => [:create, :update, :destroy]
  end
  map.resources :brand_results, :only => [:index], :member => { :follow_up => :post }
  
  map.resources :users
  map.resource :user_session
  map.resource :account, :except => [:new]
  map.signup '/signup/:invitation_token', :controller => "accounts", :action => "new"
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :invitations, :only => [:new, :create]

  map.with_options(:controller => 'pages', :action => 'show') do |pages|
    pages.connect '/about', :id => 'about'
    pages.connect '/pages/:id'
  end
end
