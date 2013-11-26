ShoverController = require '../../app/controllers/shover_controller'
ApplicationController = require '../../app/controllers/application_controller'
ShoverSocket = require '../../app/sockets/shover_socket'
MessageVerifier = require('action-base').MessageVerifier
app = require '../../app'

describe 'ShoverController', ->
  it 'is a subclass of application controller', ->
    expect(ShoverController.prototype).to.be.an.instanceof ApplicationController

  describe 'POST publish', ->
    err = res = null

    beforeEach ->
      sinon.stub ShoverSocket, 'publish'

    afterEach ->
      ShoverSocket.publish.restore()

    context 'when not given a payload', ->
      beforeEach (done) ->
        err = res = null
        request(app)
          .post('/publish')
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'payload not found' }
        expect(ShoverSocket.publish).not.to.have.been.called

    context 'when given a payload signed with invalid token', ->
      beforeEach (done) ->
        err = res = null
        invalidMessageVerifier = new MessageVerifier('invalid-secret-token')
        payload = invalidMessageVerifier.generate([123, 'foo', { foo: 123 }])
        request(app)
          .post('/publish')
          .send(p: payload)
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'invalid payload' }
        expect(ShoverSocket.publish).not.to.have.been.called

    context 'when given a valid payload', ->
      beforeEach (done) ->
        err = res = null
        payload = app.messageVerifier.generate([123, 'foo', { foo: 123 }])
        request(app)
          .post('/publish')
          .send(p: payload)
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 200 and calls ShoverSocket.publish', ->
        expect(res.statusCode).to.equal 200
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { status: 'ok' }
        expect(ShoverSocket.publish).to.have.been.calledWith 123, 'foo', foo: 123

  describe 'POST broadcast', ->
    err = res = null

    beforeEach ->
      sinon.stub ShoverSocket, 'broadcast'

    afterEach ->
      ShoverSocket.broadcast.restore()

    context 'when not given a payload', ->
      beforeEach (done) ->
        err = res = null
        request(app)
          .post('/broadcast')
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'payload not found' }
        expect(ShoverSocket.broadcast).not.to.have.been.called

    context 'when given a payload signed with invalid token', ->
      beforeEach (done) ->
        err = res = null
        invalidMessageVerifier = new MessageVerifier('invalid-secret-token')
        payload = invalidMessageVerifier.generate(['foo', { foo: 123 }])
        request(app)
          .post('/broadcast')
          .send(p: payload)
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'invalid payload' }
        expect(ShoverSocket.broadcast).not.to.have.been.called

    context 'when given a valid payload', ->
      beforeEach (done) ->
        err = res = null
        payload = app.messageVerifier.generate(['foo', { foo: 123 }])
        request(app)
          .post('/broadcast')
          .send(p: payload)
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 200 and calls ShoverSocket.broadcast', ->
        expect(res.statusCode).to.equal 200
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { status: 'ok' }
        expect(ShoverSocket.broadcast).to.have.been.calledWith 'foo', foo: 123
