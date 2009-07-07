# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_brandizzle_session',
  :secret      => '527cd27beed2c3feaf1d04d738f980bf3d5ec24ce294cc16dddc4e7861e56ccdcffacd3bc1475d8eeb05dd1016b8da5e17133f6d21f537039e34dd21e5f28692'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
