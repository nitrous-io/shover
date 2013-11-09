BaseController = require('action-base').BaseController

module.exports = class ApplicationController extends BaseController
  _addNoCacheHeaders: ->
    @response.set 'Pragma', 'no-cache'
    @response.set 'Cache-Control', 'no-store, no-cache, must-revalidate'
