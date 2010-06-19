HoptoadNotifier.configure do |config|
  config.api_key = {:project => 'brandizzle',            # the identifier you specified for your project in Redmine
                    :tracker => 'Bug',                   # the name of your Tracker of choice in Redmine
                    :api_key => 'f7q6bhZPZV4zJH7QAHFr',  # the key you generated before in Redmine (NOT YOUR HOPTOAD API KEY!)
                    :category => 'Development',          # the name of a ticket category (optional.)
                    :assigned_to => 'admin',             # the login of a user the ticket should get assigned to by default (optional.)
                    :priority => 5                       # the default priority (use a number, not a name. optional.)
                   }.to_yaml                             
  config.host = 'git.aissac.ro'                          # the hostname your Redmine runs at
  config.port = 443                                      # the port your Redmine runs at
  config.secure = true                                   # sends data to your server via SSL (optional.)
end
