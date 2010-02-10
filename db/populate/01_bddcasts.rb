def populate
  create_user("ihoka@brandizzle.com")
  create_user("jschoolcraft@brandizzle.com")
  create_user("cristi@brandizzle.com")

  User.all.each_with_index do |user, index|
    bddcasts = Brand.create_or_update(:id => index+1, :name => 'BDDCasts', :user => user)
    add_query_to_brand(bddcasts, 'bddcasts')
    add_query_to_brand(bddcasts, 'bdd screencasts')
    add_query_to_brand(bddcasts, user.login)
  
    railsbridge = Brand.create_or_update(:id => index+4, :name => 'RailsBridge', :user => user)
    add_query_to_brand(railsbridge, 'railsbridge')
    add_query_to_brand(railsbridge, 'rails workshop')
  end
end

def create_user(email)
  invitation = create_fake_invitation(email)
  login = email.split('@').first
  
  user = User.create_or_update(
    :login => login,
    :email => email,
    :password => "secret",
    :password_confirmation => "secret",
    :invitation_token => invitation.token)

  update_invitation_limit(user)
end

def add_query_to_brand(brand, query_term)
  query = Query.find_or_create_by_term(query_term)
  brand.queries << query
end

def update_invitation_limit(user)
  user.invitation_limit = 100
  user.save
end

def create_fake_invitation(email)
  invitation = Invitation.create_or_update(:recipient_email => email)
end

populate