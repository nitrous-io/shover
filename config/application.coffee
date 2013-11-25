express = require 'express'

kShoverUsername = process.env.SHOVER_USERNAME
kShoverPassword = process.env.SHOVER_PASSWORD

module.exports = (app) ->
  app.configure ->
    app.enable 'trust proxy'
    unless app.settings.env == 'test'
      app.use express.basicAuth (user, pass) ->
        user == kShoverUsername && pass == kShoverPassword
    app.use express.bodyParser()
    app.use express.methodOverride()
