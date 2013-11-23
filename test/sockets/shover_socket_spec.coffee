actionBase = require 'action-base'
BaseSocket = actionBase.BaseSocket
ShoverSocket = require '../../app/sockets/shover_socket'

describe 'ShoverSocket', ->
  socket = mockConnection = null
  userId = 1234

  beforeEach ->
    mockConnection = { send: sinon.spy(), userId: userId }
    socket = new ShoverSocket(mockConnection)

  afterEach ->
    ShoverSocket.channels = {}

  it 'is a subclass of base socket', ->
    expect(ShoverSocket.prototype).to.be.an.instanceof BaseSocket

  describe 'channels', ->
    socket1 = socket2 = socket3 = null

    beforeEach ->
      socket1 = new ShoverSocket(userId: 123)
      socket2 = new ShoverSocket(userId: 852)
      socket3 = new ShoverSocket(userId: 917)

    context 'on initialize', ->
      it "subscribes to the user's channel", ->
        expect(ShoverSocket.channels[123]).to.deep.equal [socket1]
        expect(ShoverSocket.channels[852]).to.deep.equal [socket2]
        expect(ShoverSocket.channels[917]).to.deep.equal [socket3]

      context 'when a channel has an existing subscriber', ->
        it 'adds another subscriber', ->
          socket4 = new ShoverSocket(userId: 123)
          socket5 = new ShoverSocket(userId: 123)
          expect(ShoverSocket.channels[123]).to.deep.equal [socket1, socket4, socket5]

    context 'on destroy', ->
      it "unsubscribes from the user's channel", ->
        expect(ShoverSocket.channels[123]).to.exist
        expect(ShoverSocket.channels[852]).to.exist
        expect(ShoverSocket.channels[917]).to.exist
        socket1.destroy()
        expect(ShoverSocket.channels[123]).not.to.exist
        expect(ShoverSocket.channels[852]).to.exist
        expect(ShoverSocket.channels[917]).to.exist
        socket2.destroy()
        expect(ShoverSocket.channels[123]).not.to.exist
        expect(ShoverSocket.channels[852]).not.to.exist
        expect(ShoverSocket.channels[917]).to.exist
        socket3.destroy()
        expect(ShoverSocket.channels[123]).not.to.exist
        expect(ShoverSocket.channels[852]).not.to.exist
        expect(ShoverSocket.channels[917]).not.to.exist

      context 'when a channel has multiple subscribers', ->
        it 'only unsubscribes the socket that is destroyed', ->
          socket4 = new ShoverSocket(userId: 123)
          socket5 = new ShoverSocket(userId: 123)
          expect(ShoverSocket.channels[123]).to.exist
          expect(ShoverSocket.channels[123]).to.deep.equal [socket1, socket4, socket5]
          socket4.destroy()
          expect(ShoverSocket.channels[123]).to.deep.equal [socket1, socket5]
          socket1.destroy()
          expect(ShoverSocket.channels[123]).to.deep.equal [socket5]
          socket5.destroy()
          expect(ShoverSocket.channels[123]).not.to.exist

  describe 'sending messages', ->
    socket1 = socket2 = socket3 = socket4 = socket5 = null

    beforeEach ->
      socket1 = new ShoverSocket(userId: 123)
      socket2 = new ShoverSocket(userId: 852)
      socket3 = new ShoverSocket(userId: 917)
      socket4 = new ShoverSocket(userId: 777)
      socket5 = new ShoverSocket(userId: 123)
      for socket in [socket1, socket2, socket3, socket4, socket5]
        sinon.stub socket, 'send'

    describe '.publish', ->
      it 'calls #send on all sockets for the given user id', ->
        ShoverSocket.publish(852, 'foo', bar: 123)
        expect(socket1.send).not.to.have.been.called
        expect(socket2.send).to.have.been.calledWith('foo', bar: 123)
        socket2.send.reset()
        expect(socket3.send).not.to.have.been.called
        expect(socket4.send).not.to.have.been.called
        expect(socket5.send).not.to.have.been.called
        ShoverSocket.publish(777, 'hello', world: 'yay')
        expect(socket1.send).not.to.have.been.called
        expect(socket2.send).not.to.have.been.called
        expect(socket3.send).not.to.have.been.called
        expect(socket4.send).to.have.been.calledWith('hello', world: 'yay')
        socket4.send.reset()
        expect(socket5.send).not.to.have.been.called
        ShoverSocket.publish(123, 'bar', lol: 'hehe', blah: 'beeboo')
        expect(socket1.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket2.send).not.to.have.been.called
        expect(socket3.send).not.to.have.been.called
        expect(socket4.send).not.to.have.been.called
        expect(socket5.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')

    describe '.broadcast', ->
      it 'calls #send on all sockets', ->
        ShoverSocket.broadcast('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket1.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket2.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket3.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket4.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
        expect(socket5.send).to.have.been.calledWith('bar', lol: 'hehe', blah: 'beeboo')
