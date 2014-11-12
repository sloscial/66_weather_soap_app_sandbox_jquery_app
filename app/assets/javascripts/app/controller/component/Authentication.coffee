null
###*
@class AP.controller.component.Authentication
@extends AP.controller.Controller

Handles interactions with the authentication button and login page.

See `AP.view.component.AuthenticationButton`.
###
class AP.controller.component.Authentication extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-authenticationbutton', 'action', 'onAction']
    ['.ap-authenticationformpage', 'save', 'onSave']
  ]
  
  ###*
  Shows the login page `AP.view.component.AuthenticationFormPage` if not logged
  in.  Logs out if logged in.
  ###
  onAction: (e, view) ->
    if AP.auth.Authentication.isAuthenticated()
      AP.auth.Authentication.logout()
    else
      page = AP.Viewport.showItemByClass 'AP.view.component.AuthenticationFormPage',
        backButton: true
  
  
  ###*
  Authenticates using user-provided credentials from login form.
  ###
  onSave: (e, view) ->
    values = view.getValues()
    AP.auth.Authentication.login values
