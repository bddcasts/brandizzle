ActionController::Routing::Routes.draw do |map|
  map.root :controller => "brands"
  
  map.resources :brands do |brand|
    brand.resources :searches, :only => [:create, :update, :destroy]
  end
  map.resources :results, :only => [], :member => { :follow_up => :post }
  
  map.resources :users
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  
  map.with_options(:controller => 'pages', :action => 'show') do |pages|
    pages.connect '/about', :id => 'about'
    pages.connect '/pages/:id'
  end
end
