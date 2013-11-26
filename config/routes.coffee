to = require('action-base').routeTo
c = require '../app/controllers'

module.exports = (app) ->
  app.get '/', to c.HomeController, 'index'
  app.post '/publish', to c.ShoverController, 'publish'
  app.post '/broadcast', to c.ShoverController, 'broadcast'
