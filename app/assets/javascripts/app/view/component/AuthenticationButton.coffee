null
###*
@class AP.view.component.AuthenticationButton
@extends AP.view.Button

A login button (when user is logged out) and a logout button (when user is
logged in).
###
class AP.view.component.AuthenticationButton extends AP.view.Button
  ###*
  @inheritdoc
  ###
  className: 'ap-button ap-authenticationbutton'
  
  ###*
  Sets `title` to `authenticated_title` when the user is authenticated.
  @inheritdoc
  ###
  getObjectData: ->
    data = super
    data.title = data.authenticated_title if AP.auth.Authentication.isAuthenticated()
    data
