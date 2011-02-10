# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mdm_session',
  :secret      => 'db552c3038196dd43bb45b544ee86e34384a277c61785c53b2c25d758b3c41c3476f53d40f0ec27117dbe3989ee4d0de1f300114b538b9a424f0281bd4c073a8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
