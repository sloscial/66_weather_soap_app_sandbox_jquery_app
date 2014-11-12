CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class PageButtonTestCase
In addition to existence verification, this test case clicks the button and
verifies the resulting page is the intended page.
###
class PageButtonTestCase extends CasperTestCase
  ###*
  @property {Boolean}
  Do not automatically execute the `verifyExists` test.  This test clicks the
  page button thus implicitly testing existence.
  ###
  #autoVerifyExists: false
  
  ###*
  @property {String}
  CSS selector for the tested component's target page, if any.
  ###
  targetPageSelector: null
  
  ###*
  Gets the target page selector as specified in the tested component's
  `page` property.  If a page is specified, its selector is saved into
  this test case's `targetPageSelector` property.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    super
    @getTargetPageSelector()
  
  ###*
  Clicks the page button and verifies the resulting page is the intended
  page, if a target page was specified.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    @casper.then ->
      if !self.targetPageSelector
        @test.info "Target page is unspecified.  Skipping tests..."
      else
        @test.assertDoesntExist self.targetPageSelector, "Target page does not exist"
        @test.info "Clicking page button..."
        @click self.selector
        @test.assertExists self.targetPageSelector, "Target page exists."


module.exports = PageButtonTestCase
