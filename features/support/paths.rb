module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'
    when /the about page/
      '/about'
    when /the brand edit page for "([^\"]*)"/
      edit_brand_path(Brand.find_by_name($1))
    when /my info page/
      edit_user_info_path
    when /the team page/
      team_path
      
    #account related paths
    when /the registration page/
      invitation = Invitation.first
      signup_path(invitation.token)
    when /the login page/
      new_user_session_path
    when /my account page/
      edit_account_path

    # added by script/generate pickle path

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page

    when /^the (.+?) page$/                                         # translate to named route
      send "#{$1.downcase.gsub(' ','_')}_path"
  
    # end added by pickle path

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
