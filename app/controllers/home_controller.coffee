ApplicationController = require './application_controller'

module.exports = class HomeController extends ApplicationController
  index: ->
    @response.send 200, 'shover OK'
