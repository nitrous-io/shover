to = require('action-base').routeTo
c = require '../app/controllers'

module.exports = (app) ->
  app.get '/', to c.HomeController, 'index'
  app.post '/p', to c.ShoverController, 'publish'
  app.post '/b', to c.ShoverController, 'broadcast'
