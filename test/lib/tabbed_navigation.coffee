CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class TabbedNavigationTestCase
In addition to existence verification, this test case clicks the second item
in navigation (if any) and verifies the resulting page is the intended page.
###
class TabbedNavigationTestCase extends CasperTestCase
  ###*
  @property {String}
  The expected page title of the second navigation item, if any.
  ###
  expectedSecondTitle: null
  
  ###*
  Saves the expected page title of the second navigation item to this test
  case's `expectedSecondTitle` property.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    super
    if @component.childrenTitles.length > 1
      @expectedSecondTitle = self.component.childrenTitles[1]
  
  ###*
  If navigation has at least one item, the first item's page title is tested.
  If navigation has two or more items, the test navigates to the second item
  and verifies the resulting page title.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    if @component.childrenSelectors.length > 0
      @casper.waitForSelector @component.childrenSelectors[0], ->
        @test.assertTitle self.component.childrenTitles[0], "Default tabbed navigation title \"#{self.component.childrenTitles[0]}\" is the title of its first item"
    if @component.childrenSelectors.length > 1
      @casper.then ->
        @click "#{self.component.childrenSelectors[0]} [data-role='footer'] [data-view-class='#{self.component.items[1]}']"
        @test.assertTitle self.expectedSecondTitle, "After navigating to second tab, page title is udpated to \"#{self.expectedSecondTitle}\""


module.exports = TabbedNavigationTestCase
