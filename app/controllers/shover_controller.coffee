ApplicationController = require './application_controller'
ShoverSocket = require '../sockets/shover_socket'
app = require '../../app'

module.exports = class ShoverController extends ApplicationController
  publish: ->
    @_processRequest (payload) =>
      ShoverSocket.publish payload[0], payload[1], payload[2]

  broadcast: ->
    @_processRequest (payload) =>
      ShoverSocket.broadcast payload[0], payload[1]

  _processRequest: (cb) ->
    if !@params.p?
      @response.send 400, error: 'payload not found'
    else if payload = app.messageVerifier.verify(@params.p)
      @response.send 200, status: 'ok'
      cb(payload)
    else
      @response.send 400, error: 'invalid payload'
