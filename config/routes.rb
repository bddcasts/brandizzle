ActionController::Routing::Routes.draw do |map|
  map.with_options(:controller => 'pages', :action => 'show') do |pages|
    pages.connect '/about', :id => 'about'
    pages.connect '/pages/:id'
  end
end
