# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_migrate_session',
  :secret      => '6fd0674adaf6420f8b6023cf14edf7370d0c6a7e2649155b9f9756abc562acffe4d15669f332a057d27aeaa41965e29e535a4113721a9d0d07adb8a5d1818119'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
