CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class QueryObjectFormPageTestCase
A simple query object form page test case.
###
class QueryObjectFormPageTestCase extends CasperTestCase
  ###*
  @property {Boolean}
  Do not automatically execute the `verifyExists` test.  This test submits the
  form thus implicitly testing existence.
  ###
  #autoVerifyExists: false
  
  ###*
  @property {Object}
  Hash of key/values used to fill form.
  ###
  instanceData: null
  
  ###*
  @property {Object}
  Hash of key/values for form fields that were actually filled.  Filled form
  fields may be a subset of `instanceData`.
  ###
  filledData: null
  
  ###*
  @property {String}
  CSS selector for the tested component's target page, if any.
  ###
  targetPageSelector: null
  
  ###*
  Generates random form data before carrying out the test.  Gets the target page
  selector, if any.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    super
    @generateRandomFormData()
    @getTargetPageSelector()
  
  ###*
  Fills form, submits it, and verifies the intended page is shown.
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    super
    @casper.then ->
      if !self.targetPageSelector
        @test.info "Target page is unspecified, but is required.  Skipping tests..."
      else
        @then ->
          @test.assertDoesntExist self.targetPageSelector, "Target page does not exist"
        self.fillForm()
        self.submitForm()
        @then ->
          @test.assertVisible self.targetPageSelector, "Target page is visible."
          @test.info "Clicking back button..."
          @click "#{self.targetPageSelector} .ap-backbutton"
          @test.assertVisible self.selector, "Subject page is visible."


module.exports = QueryObjectFormPageTestCase
