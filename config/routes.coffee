to = require('action-base').routeTo
c = require '../app/controllers'

module.exports = (app) ->
  app.get '/', to c.HomeController, 'index'
