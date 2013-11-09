ApplicationController = require '../../app/controllers/application_controller'
BaseController = require('action-base').BaseController
app = require '../../app'

describe 'ApplicationController', ->
  controller = null

  beforeEach (done) ->
    controller = new ApplicationController {app: app}, {}
    done()

  it 'is a subclass of BaseController', ->
    expect(controller).to.be.an.instanceOf BaseController

  describe '#_addNoCacheHeaders', ->
    beforeEach ->
      controller.response.set = sinon.stub()
      controller._addNoCacheHeaders()

    it 'adds headers that prevent client-side caching', ->
      response = controller.response
      expect(response.set).to.have.been.calledWith 'Pragma', 'no-cache'
      expect(response.set).to.have.been.calledWith 'Cache-Control', 'no-store, no-cache, must-revalidate'
