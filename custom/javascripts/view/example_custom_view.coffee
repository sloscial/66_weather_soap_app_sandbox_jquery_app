class WeatherSoapAppSdk.views.ExampleCustomView extends AP.view.Content
  viewIntro: '''
    Views are used to display information to users and to build
    user interfaces.  Add custom views to build your own UI.
  '''
  customViewContent: '''
    This example custom content component extends
    <code>AP.view.Content</code>.  Save your own custom views to
    <code>app/view/custom/</code> to enjoy automatic compilation into builds
    when using Grunt.  See <code>README.md</code> for more information.
  '''
  template: '''
    <p>{{ viewIntro }}</p>
    <p>{{ customViewContent }}</p>
  '''
