actionBase = require 'action-base'
MessageVerifier = actionBase.MessageVerifier
AuthTokenVerifier = actionBase.AuthTokenVerifier
app = require '../app'

describe 'app', ->
  it 'has a message verifier', ->
    expect(app.messageVerifier).to.be.an.instanceOf MessageVerifier
    expect(app.messageVerifier.secret).to.equal app.settings.secretToken

  it 'has a auth token verifier', ->
    expect(app.authTokenVerifier).to.be.an.instanceOf AuthTokenVerifier
    expect(app.authTokenVerifier.messageVerifier).to.equal app.messageVerifier
