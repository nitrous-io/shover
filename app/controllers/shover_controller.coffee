ApplicationController = require './application_controller'
ShoverSocket = require '../sockets/shover_socket'

module.exports = class ShoverController extends ApplicationController
  publish: ->
    @_processRequest (@params.u? && @params.e?), (data) =>
      ShoverSocket.publish @params.u, @params.e, data

  broadcast: ->
    @_processRequest @params.e?, (data) =>
      ShoverSocket.broadcast @params.e, data

  _returnInvalidParams: ->
    @response.send 400, error: 'invalid params'

  _processRequest: (prerequisite, cb) ->
    unless prerequisite
      @_returnInvalidParams()
      return
    try
      data = JSON.parse(@params.d)
    catch e
      @_returnInvalidParams()
      return
    @response.send 200, status: 'ok'
    cb(data)
