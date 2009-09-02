bddcasts = Brand.create_or_update(:id => 1, :name => 'BDDCasts')

bddcasts.add_search('bddcasts')
bddcasts.add_search('jschoolcraft')
bddcasts.add_search('ihoka')
bddcasts.add_search('bdd screencasts')
bddcasts.add_search('cucumber rspec screencast')
bddcasts.add_search('behavior driven development')

railsbridge = Brand.create_or_update(:id => 2, :name => 'RailsBridge')

railsbridge.add_search('railsbridge')
railsbridge.add_search('rails workshop')
railsbridge.add_search('railstutor')
railsbridge.add_search('rails mentor')
railsbridge.add_search('rails activist')
railsbridge.add_search('rails community')