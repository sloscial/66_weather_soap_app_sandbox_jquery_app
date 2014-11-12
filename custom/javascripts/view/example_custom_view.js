(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WeatherSoapAppSdk.views.ExampleCustomView = (function(_super) {
    __extends(ExampleCustomView, _super);

    function ExampleCustomView() {
      _ref = ExampleCustomView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ExampleCustomView.prototype.viewIntro = 'Views are used to display information to users and to build\nuser interfaces.  Add custom views to build your own UI.';

    ExampleCustomView.prototype.customViewContent = 'This example custom content component extends\n<code>AP.view.Content</code>.  Save your own custom views to\n<code>app/view/custom/</code> to enjoy automatic compilation into builds\nwhen using Grunt.  See <code>README.md</code> for more information.';

    ExampleCustomView.prototype.template = '<p>{{ viewIntro }}</p>\n<p>{{ customViewContent }}</p>';

    return ExampleCustomView;

  })(AP.view.Content);

}).call(this);
