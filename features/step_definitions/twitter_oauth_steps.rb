Given /^a Twitter user "([^\"]*)" registered with BrandPulse$/ do |name|
  Given %Q{a team "t" exists}
  Given %Q{a twitter user "#{name}" exists with oauth_token: "foo", oauth_secret: "secret", name: "#{name}", team: team "t"}
  Given %Q{an user detail exists with user: user "#{name}", twitter_screen_name: "#{name}"} 
  Given %Q{an account exists with team: team "t"} 
  
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.attempted_record = User.find_by_oauth_token("foo")
    end
  end
end

Given /^a Twitter user "([^\"]*)" that is not registered with BrandPulse$/ do |twitter_name|
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.errors.add_to_base("Could not find user in our database")
    end
  end
end

Given /^user "([^\"]*)" has not authorized BrandPulse to use Twitter account$/ do |twitter_name|
  User.class_eval do
    define_method("user_twitter_name") do
      twitter_name
    end
    
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "PUT"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_info?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.twitter_uid = "12355434"
      self.name = user_twitter_name
      self.oauth_token = "foo"
      self.oauth_secret = "bar"
    end
  end
end

Given /^a Twitter user that denies access to BrandPulse$/ do
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?denied=foo"
    end
  end
  
  User.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "PUT"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_info?denied=foo"
    end
 end
end