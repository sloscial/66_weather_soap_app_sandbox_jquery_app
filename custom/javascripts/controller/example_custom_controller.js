/*
Controllers are used to handle user interaction events and direct
application flow.  Add custom controllers to add more functionality to your app.

This example custom controller extends
<code>AP.controller.Controller</code>.  Save your own custom controllers to
<code>app/controller/custom/</code> to enjoy automatic compilation into builds
when using Grunt.  See <code>README.md</code> for more information.
*/


(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WeatherSoapAppSdk.controllers.ExampleCustomController = (function(_super) {
    __extends(ExampleCustomController, _super);

    function ExampleCustomController() {
      _ref = ExampleCustomController.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ExampleCustomController.prototype.events = [['.ap-custom-selector', 'event', 'onEvent']];

    ExampleCustomController.prototype.onEvent = function(e) {};

    return ExampleCustomController;

  })(AP.controller.Controller);

}).call(this);
