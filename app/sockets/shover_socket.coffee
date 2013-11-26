actionBase = require 'action-base'
BaseSocket = actionBase.BaseSocket

module.exports = class ShoverSocket extends BaseSocket
  namespace: 'shover'

  @channels: {}

  @publish: (userId, event, data) ->
    if @channels.hasOwnProperty(userId) && channel = @channels[userId]
      for socket in channel
        socket.send event, data

  @broadcast: (event, data) ->
    for own userId, channel of @channels
      for socket in channel
        socket.send event, data

  initialize: ->
    # subscribe
    channel = @constructor.channels[@connection.userId] ||= []
    channel.push this

  destroy: ->
    if channel = @constructor.channels[@connection.userId]
      # unsubscribe
      for subscriber, i in channel
        if subscriber == this
          channel.splice i, 1
          break
      if channel.length == 0
        @constructor.channels[@connection.userId] = undefined
