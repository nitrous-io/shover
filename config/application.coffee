express = require 'express'

module.exports = (app) ->
  app.configure ->
    app.enable 'trust proxy'
    app.use express.bodyParser()
    app.use express.methodOverride()
