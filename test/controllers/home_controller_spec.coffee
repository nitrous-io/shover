HomeController = require '../../app/controllers/home_controller'
ApplicationController = require '../../app/controllers/application_controller'
app = require '../../app'

describe 'HomeController', ->
  it 'is a subclass of application controller', ->
    expect(HomeController.prototype).to.be.an.instanceof ApplicationController

  describe 'GET /', ->
    err = res = null

    beforeEach (done) ->
      err = res = null
      request(app)
        .get('/')
        .end (e, r) ->
          err = e; res = r; done()

    it 'returns 200 OK', ->
      expect(res.statusCode).to.equal 200

  describe 'GET /ping', ->
    err = res = null

    beforeEach (done) ->
      err = res = null
      request(app)
        .get('/ping')
        .end (e, r) ->
          err = e; res = r; done()

    it 'returns 200 OK', ->
      expect(res.statusCode).to.equal 200

