_ = require 'underscore'
env = process.env.NODE_ENV

settings =
  common:
    secretToken: process.env.SECRET_TOKEN
    airbrakeAPIKey: process.env.AIRBRAKE_API_KEY
  development: {}
  test: {}
  staging: {}
  production: {}

module.exports = _.extend settings.common, settings[env]
