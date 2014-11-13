CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class ListTestCase
In addition to existence verification, this test case clicks an item in the
list if a target `page` is specified and verifies the resulting page is the
intended page.
###
class ListTestCase extends CasperTestCase
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
    # no need to test existence when interacting with component
    # interaction implicitly tests existence
    @autoVerifyExists = false if self.targetPageSelector
    @getTargetPageSelector()
  
  ###*
  Clicks the first list item and verifies the resulting page is the intended
  page, if a target page was specified.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    @casper.then ->
      if !self.targetPageSelector
        @test.info "Target page is unspecified.  Skipping tests..."
      else
        @test.assertDoesntExist self.targetPageSelector, "Target page does not exist."
        @test.info "Clicking list item..."
        @click "#{self.selector} .ap-dataviewitem:first-child"
        @test.assertExists self.targetPageSelector, "Target page exists."


module.exports = ListTestCase
