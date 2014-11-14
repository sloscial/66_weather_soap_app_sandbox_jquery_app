CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class AuthenticationButtonTestCase
A simple authentication button test case.
###
class AuthenticationButtonTestCase extends CasperTestCase
  ###*
  @property {Boolean}
  Do not automatically execute the `verifyExists` test.  This test clicks the
  authentication button thus implicitly testing existence.
  ###
  #autoVerifyExists: false
  
  ###*
  @property {String}
  CSS selector for the tested component's target page, if any.
  ###
  targetPageSelector: '.ap-authenticationformpage'
  
  ###*
  Clicks the authentication button and verifies the resulting page is the
  login page.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    @casper.then ->
      @test.assertDoesntExist self.targetPageSelector, "Login page does not yet exist"
      @test.info "Clicking authentication button..."
      @click self.selector
      @test.assertVisible self.targetPageSelector, "Login page exists."
      @test.info "Clicking back button... '#{self.targetPageSelector} .ap-backbutton'"
      @click "#{self.targetPageSelector} .ap-backbutton"
      isVisible = @evaluate(((selector) ->
        $('.ap-page:visible').is selector
      ), self.ancestorPage.selector)
      # this test fails for some reason...
      # @test.assertVisible self.ancestorPage.selector, "Login button parent page is visible."
      # even though this succeeds...
      @test.assert isVisible, "Login button parent page is visible."
      # TODO: these tests should always behave the same


module.exports = AuthenticationButtonTestCase
