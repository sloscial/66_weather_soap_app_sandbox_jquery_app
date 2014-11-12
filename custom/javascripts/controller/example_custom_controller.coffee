###
Controllers are used to handle user interaction events and direct
application flow.  Add custom controllers to add more functionality to your app.

This example custom controller extends
<code>AP.controller.Controller</code>.  Save your own custom controllers to
<code>app/controller/custom/</code> to enjoy automatic compilation into builds
when using Grunt.  See <code>README.md</code> for more information.
###
class WeatherSoapAppSdk.controllers.ExampleCustomController extends AP.controller.Controller
  events: [
    ['.ap-custom-selector', 'event', 'onEvent']
  ]
  
  onEvent: (e) ->
    # Executed whenever `event` is trigged on DOM elements matching the
    # selector `.ap-custom-selector`.
