ShoverController = require '../../app/controllers/shover_controller'
ApplicationController = require '../../app/controllers/application_controller'
ShoverSocket = require '../../app/sockets/shover_socket'
app = require '../../app'

describe 'ShoverController', ->
  it 'is a subclass of application controller', ->
    expect(ShoverController.prototype).to.be.an.instanceof ApplicationController

  describe 'POST publish', ->
    err = res = null

    context 'when u and e params are not given', ->
      beforeEach (done) ->
        err = res = null
        request(app)
          .post('/p')
          .send(d: '{"foo": 123}')
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'invalid params' }

    context 'when u, e and d params are given', ->
      context 'when d is not json', ->
        beforeEach (done) ->
          err = res = null
          request(app)
            .post('/p')
            .send(u: 123, e: 'foo', d: 'notjson')
            .end (e, r) ->
              err = e; res = r; done()

        it 'returns 400 bad request', ->
          expect(res.statusCode).to.equal 400
          expect(res.headers['content-type']).to.match /json/
          expect(res.body).to.deep.equal { error: 'invalid params' }

      context 'when d is json', ->
        beforeEach (done) ->
          err = res = null
          sinon.stub ShoverSocket, 'publish'
          request(app)
            .post('/p')
            .send(u: 123, e: 'foo', d: '{"foo": 123}')
            .end (e, r) ->
              err = e; res = r; done()

        afterEach ->
          ShoverSocket.publish.restore()

        it 'returns 200 and calls ShoverSocket.publish', ->
          expect(res.statusCode).to.equal 200
          expect(res.headers['content-type']).to.match /json/
          expect(res.body).to.deep.equal { status: 'ok' }
          expect(ShoverSocket.publish).to.have.been.calledWith 123, 'foo', foo: 123

  describe 'POST broadcast', ->
    err = res = null

    context 'when e param is not given', ->
      beforeEach (done) ->
        err = res = null
        request(app)
          .post('/b')
          .send(d: '{"foo": 123}')
          .end (e, r) ->
            err = e; res = r; done()

      it 'returns 400 bad request', ->
        expect(res.statusCode).to.equal 400
        expect(res.headers['content-type']).to.match /json/
        expect(res.body).to.deep.equal { error: 'invalid params' }

    context 'when e and d params are given', ->
      context 'when d is not json', ->
        beforeEach (done) ->
          err = res = null
          request(app)
            .post('/b')
            .send(e: 'foo', d: 'notjson')
            .end (e, r) ->
              err = e; res = r; done()

        it 'returns 400 bad request', ->
          expect(res.statusCode).to.equal 400
          expect(res.headers['content-type']).to.match /json/
          expect(res.body).to.deep.equal { error: 'invalid params' }

      context 'when d is json', ->
        beforeEach (done) ->
          err = res = null
          sinon.stub ShoverSocket, 'broadcast'
          request(app)
            .post('/b')
            .send(e: 'foo', d: '{"foo": 123}')
            .end (e, r) ->
              err = e; res = r; done()

        afterEach ->
          ShoverSocket.broadcast.restore()

        it 'returns 200 and calls ShoverSocket.publish', ->
          expect(res.statusCode).to.equal 200
          expect(res.headers['content-type']).to.match /json/
          expect(res.body).to.deep.equal { status: 'ok' }
          expect(ShoverSocket.broadcast).to.have.been.calledWith 'foo', foo: 123
