CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class UrlButtonTestCase
In addition to existence verification, this test case clicks the button and
verifies the openned URL is the intended URL.
###
class UrlButtonTestCase extends CasperTestCase
  ###*
  @property {Boolean}
  Do not automatically execute the `verifyExists` test.  This test clicks the
  URL button thus implicitly testing existence.
  ###
  #autoVerifyExists: false
  
  ###*
  @property {String}
  The expected URL of the button.
  ###
  expectedUrl: null
  
  ###*
  Gets the expected URL of the button from the view instance in the test
  environment, passing it through string interpolation first.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    super
    @casper.then ->
      self.expectedUrl = @evaluate(((selector) ->
        $(selector).find('a').removeAttr('target').attr('href')
        $(selector).data('view').renderAttr('url')
      ), self.selector)
  
  ###*
  Clicks the button and verifies the openned URL is the intended URL.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    @casper.then ->
      @test.info "Clicking URL button..."
      @click "#{self.selector} a"
    @casper.then ->
      @test.assertEquals @getCurrentUrl().indexOf(self.expectedUrl), 0, "Successfully opened '#{self.expectedUrl}'"
  
  ###*
  Navigates the browser to the test page URL, since it would otherwise remain
  on the URL button target page.
  @param {CasperTestCase} self this test case instance
  ###
  after: (self) ->
    @casper.thenOpen @testUrl

module.exports = UrlButtonTestCase
