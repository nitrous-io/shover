process.env.NODE_ENV ?= 'development'
process.title = 'shover'

express    = require 'express'
http       = require 'http'
_          = require 'underscore'
sockjs     = require 'sockjs'
actionBase = require 'action-base'

module.exports = app = express()

# settings
settings = require './config/settings'
env = app.settings.env
_.extend app.settings, settings

# express config
require('./config/application')(app)

# message verifier
MessageVerifier = actionBase.MessageVerifier
AuthTokenVerifier = actionBase.AuthTokenVerifier
app.messageVerifier = new MessageVerifier app.settings.secretToken
app.authTokenVerifier = new AuthTokenVerifier 'rainbow', app.messageVerifier

# routes
require('./config/routes')(app)

process.on 'uncaughtException', (err) ->
  console.log err
  console.log err.message
  console.log err.stack

if require.main == module || require.main.filename.match /boot\.js/
  server = http.createServer app

  # sockjs
  SocketConnection = actionBase.SocketConnection
  ShoverSocket = require './app/sockets/shover_socket'

  app.sock = sock = sockjs.createServer
    sockjs_url: 'http://cdn.sockjs.org/sockjs-0.3.min.js'

  sock.on 'connection', (ws) ->
    sc = new SocketConnection(ws, app.authTokenVerifier)
    sc.register ShoverSocket

  sock.installHandlers server, prefix: '/ws'

  server.listen(process.env.PORT || 3003)

  unless address = server.address()
    console.error 'Could not start Shover!'
    return

  console.log "Shover listening on port #{address.port} in #{env} mode"
