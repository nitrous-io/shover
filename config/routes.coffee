to = require('action-base').routeTo
c = require '../app/controllers'

module.exports = (app) ->
  app.get '/', to c.HomeController, 'index'
  # Used by the monitoring service to see if the service is up
  app.get '/ping', to c.HomeController, 'index'
  app.post '/publish', to c.ShoverController, 'publish'
  app.post '/broadcast', to c.ShoverController, 'broadcast'
