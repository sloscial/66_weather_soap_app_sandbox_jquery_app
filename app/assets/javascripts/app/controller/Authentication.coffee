null
###*
@class AP.controller.Authentication
@extends AP.controller.Controller

Handles events related to authentication.  On any auth change event, the app
is reloaded.  On authentication error, a message is shown to the user.
###
class AP.controller.Authentication extends AP.controller.Controller
  initialize: ->
    super
    @listenTo AP.auth.Authentication, 'auth:authenticated', @onAuthChange
    @listenTo AP.auth.Authentication, 'auth:deauthenticated', @onAuthChange
    @listenTo AP.auth.Authentication, 'auth:error', @onAuthError
  
  ###*
  Reloads app on any auth change event.
  ###
  onAuthChange: ->
    window.location.reload()
  
  ###*
  Displays a message to the user when an authentication error occurs.
  ###
  onAuthError: ->
    page = AP.Viewport.add
      name: 'Dialog'
      pageTitle: 'Login Error'
      items: [
        name: 'Content'
        className: 'ap-content ap-text-center'
        content: 'Your login request was not accepted.  Please try again.'
      ]
    page.show()
