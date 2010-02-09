def populate
  istvan = User.create_or_update(:id => 1, :login => "ihoka", :email => "ihoka@brandizzle.com", :password => "secret", :password_confirmation => "secret")
  istvan.activate!

  jeff = User.create_or_update(:id => 2, :login => "jschoolcraft", :email => "jschoolcraft@brandizzle.com", :password => "secret", :password_confirmation => "secret")
  jeff.activate!

  cristi = User.create_or_update(:id => 3, :login => "cristi", :email => "cristi@brandizzle.com", :password => "secret", :password_confirmation => "secret")
  cristi.activate!

  [istvan, jeff, cristi].each_with_index do |user, index|
    bddcasts = Brand.create_or_update(:id => index+1, :name => 'BDDCasts', :user => user)
  
    add_query_to_brand(bddcasts, 'bddcasts')
    add_query_to_brand(bddcasts, 'bdd screencasts')
    add_query_to_brand(bddcasts, user.login)
    # bddcasts.add_search('cucumber rspec screencast')
    # bddcasts.add_search('behavior driven development')
  
    railsbridge = Brand.create_or_update(:id => index+4, :name => 'RailsBridge', :user => user)
  
    add_query_to_brand(railsbridge, 'railsbridge')
    add_query_to_brand(railsbridge, 'rails workshop')
    # railsbridge.add_search('railstutor')
    # railsbridge.add_search('rails mentor')
    # railsbridge.add_search('rails activist')
    # railsbridge.add_search('rails community')
  end
end

def add_query_to_brand(brand, query_term)
  query = Query.find_or_create_by_term(query_term)
  brand.queries << query
end

populate