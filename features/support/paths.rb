module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'
    when /the about page/
      '/about'
    when /the dashboard/
      brand_results_path
    when /the brand edit page for "([^\"]*)"/
      edit_brand_path(Brand.find_by_name($1))

    #account related paths
    # when /the registration page/ #without invitations
    #   new_account_path
    when /the registration page/
      invitation = Invitation.first
      signup_path(invitation.token)
    when /the login page/
      new_user_session_path
    when /my account page/
      edit_account_path

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
