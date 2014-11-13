# Running `WeatherSoapApp`

Run the application locally using [Pow](http://pow.cx).  Install POW.  Load the
app into POW:

    ln -s ~/path/to/weather_soap_app ~/.pow/weather_soap_app

Access the app in a browser at `http://weather_soap_app.dev`.

Be sure the backend server is running at the URL specified in `AP.baseUrl`,
found in `/app/assets/javascripts/app/controller/main.coffee`.
Typically you'll develop against a local backend server, but you may also
develop against a remote server, such as a test or dev environment.

# Developing with Grunt

Grunt is a NodeJS-based task runner.  It helps automate common tasks, such as
asset compilation, minification, and testing.  Grunt tasks are included for this
application in `Gruntfile.coffee`.

Follow the directions below to get up and running with Grunt.

## Prerequisites

- [Ruby 2.1.0](http://www.ruby-lang.org/en/)
- [Bundler](http://gembundler.com)
- [NodeJS](http://nodejs.org)
- [CasperJS](http://casperjs.org)

## Install Ruby Gems

From the root directory of the application (where `Gemfile` is
located), install Ruby gems:

    bundle install

## Install NodeJS Modules

From the root directory of the application (where `Gruntfile.coffee` is
located), install NodeJS modules:

    npm install

## Build for Production

To compile assets and create a full minified production build, run the
build task:

    grunt build

## Development

During development, a full minified application build is unnecessary.  To
recompile assets without minifying:

    grunt compile

Please note that `grunt build` must be run once before compiling.  Normally
`public/index.html` loads the fully compiled and minified assets.  During
development, however, it should load unminified assets.  Edit
`public/index.html` and follow the directions in the comments to enable development.

## Automatic Compilation & Testing

Since it's cumbersome to manually compile assets after every change during
development, the application's `Gruntfile.coffee` includes a `watch` task.  The
task monitors changes to the application's `coffee` and `sass` assets,
automatically compiling (but not minifying) them.  Run the following command
before making changes:

    grunt watch

UI tests are also executed by the `watch` task.  When changing the UI
significantly, some or all tests may fail.  You may disable auto-testing by
editing the `watch` task in `Gruntfile.coffee`.

## Running Tests

The application comes with a complete UI test suite.  Execute tests from grunt:

    grunt test


# App Customization

You may customize this app in one of two ways:

* Edit existing controllers and views
* Build custom controllers and views

## Edit Existing Controllers and Views

App source code is found in `/app/assets/`.  Most customization occurs in
CoffeeScript source files, found in `/app/assets/javascripts/`.  Browse the
`controller` and `view` subfolders for examples.

## Build Custom Controllers and Views

Custom source code may be included and is incorporated automatically into the
app by running `grunt build` (see above section regarding Grunt).  Custom
sources are found in `/custom/`.


# Custom Views

Custom views are easy to build.  And when using `grunt build` or `grunt watch`,
custom views are automatically incorporated into your app.

For example, a simple view with template is as simple as:

    class WeatherSoapAppSdk.views.ExampleCustomView extends AP.view.Content
      title: 'Example'
      content: 'Hello World!'
      template: '''
        <p>{{ title }}</p>
        <p>{{ content }}</p>
      '''

Attach your views to the `WeatherSoapAppSdk.views` namespace.  This
ensures that views can be looked-up automatically _by name_. For example, views
may list child views with strings instead of fully-qualified identifiers both
for simplicity and to prevent errors when a named view is not yet loaded.

  class WeatherSoapAppSdk.views.AnotherView extends AP.view.Content
    items: [
      'ExampleCustomView'
    ]


# Custom Controllers

Controllers are responsible for showing and hiding views, loading data for
views, and for listening to and handling events (both internal and
user-initiated).  Custom controllers are automatically incorporated into your
app when using `grunt build` or `grunt watch`.

For example, a simple controller that listens to button clicks:

    class WeatherSoapAppSdk.controllers.ExampleCustomController extends AP.controller.Controller
      events: [
        ['.ap-custom-btn', 'action', 'onButtonAction']
      ]
  
      onButtonAction: (e) ->
        # do something

Custom controllers _must be instantiated_ once and only once.  Most views are
instantiated in the main controller located
in `/app/assets/javascripts/app/controller/component.main.coffee`.  Add a line
to the `initializeControllers` method:

    new WeatherSoapAppSdk.controllers.ExampleCustomController
