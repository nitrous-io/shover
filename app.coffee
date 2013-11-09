process.env.NODE_ENV ?= 'development'
process.title = 'shover'

express    = require 'express'
http       = require 'http'
_          = require 'underscore'
sockjs     = require 'sockjs'

module.exports = app = express()

# settings
settings = require './config/settings'
env = app.settings.env
_.extend app.settings, settings

# express config
require('./config/application')(app)

# routes
require('./config/routes')(app)

process.on 'uncaughtException', (err) ->
  console.log err
  console.log err.message
  console.log err.stack

if require.main == module || require.main.filename.match /boot\.js/
  server = http.createServer app

  server.listen(process.env.PORT || 3003)

  unless address = server.address()
    console.error 'Could not start Shover!'
    return

  console.log "Shover listening on port #{address.port} in #{env} mode"
