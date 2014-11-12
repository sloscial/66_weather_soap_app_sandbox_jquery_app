null
###*
@class AP.view.component.AuthenticationFormPage
@extends AP.view.Page

Login page.  Using authentication settngs from the `AP.auth.Authentication`
module, username and password fields are generated.
###
class AP.view.component.AuthenticationFormPage extends AP.view.Page
  ###*
  @inheritdoc
  ###
  className: 'ap-page ap-authenticationformpage'
  
  ###*
  @inheritdoc
  ###
  events:
    'action': 'onAction'
  
  ###*
  @inheritdoc
  Adds an anonymous `AP.view.ModelForm` view instance with fields for username
  and password.  See `AP.auth.Authentication`.
  ###
  initializeItems: ->
    super
    authSettings = AP.auth.Authentication.getAuthenticationSettings()
    formFields = {}
    formFields[authSettings.lookup_field] =
      label: 'Username'
      type: 'string'
      name: authSettings.lookup_field
      inputAttributes:
        autocomplete: 'off'
        autocorrect: 'off'
        autocapitalize: 'off'
    formFields[authSettings.match_field] =
      label: 'Password'
      type: 'password'
      name: authSettings.match_field
    @authForm = @showItemByClass 'AP.view.ModelForm',
      model: AP.auth.Authentication.getAuthenticatableObject()
      formFields: formFields
      submitButtonTitle: 'Login'
      onSave: ->
        # pass
