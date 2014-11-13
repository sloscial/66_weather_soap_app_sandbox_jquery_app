CasperTestCase = require('./test/lib/test_case.coffee')


###*
@class UpdateObjectFormPageTestCase
In addition to existence verification, this test case fills the update form,
submits it, and verifies the sent data with data actually saved into the mock
backend datastore.
###
class UpdateObjectFormPageTestCase extends CasperTestCase
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
  @property {Object}
  Hash of key/values for data actually saved into the mock backend datastore.
  ###
  savedInstanceData: null
  
  ###*
  @property {String}
  CSS selector for the tested component's success target page, if any.
  ###
  targetPageSelector: null
  
  ###*
  Generates random form data before carrying out the test.  Removes the ID
  from the generated data, since a random ID would result in a POST that
  creates a new record.  Gets the success target page selector, if any.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    super
    @generateRandomFormData()
    @getTargetPageSelector()
    # remove randomly generated ID, since this
    # is meant to apply to an existing record
    @casper.then ->
      delete self.instanceData.id
  
  ###*
  Fills form, submits it, and verifies filled data with saved data.
  @param {CasperTestCase} self this test case instance
  ###    
  test: (self) ->
    super
    if @component.success_page
      @casper.then ->
        @test.assertDoesntExist self.targetPageSelector, "Target page does not exist"
    @fillForm()
    @submitForm()
    @getSavedInstanceData('first')
    @casper.then ->
      @each self.filledData, (casper, data) =>
        @test.assertEquals data[1], self.savedInstanceData[data[0]], "Verified updated instance data for '#{data[0]}' field (value:  '#{data[1]}')"
      # there are three possible immediate success outcomes
      if self.targetPageSelector
        # show a success page
        @test.assertVisible self.targetPageSelector, "Success page exists."
      else if self.component.success_message
        # show a success message dialog
        @test.assertVisible '.ap-dialog', "Success message dialog exists."
        @test.info "Clicking back button..."
        @click ".ap-dialog .ap-backbutton"
        if self.component.success_action != 'Back'
          @test.assertVisible self.selector, "Subject page is visible."
        else
          @test.assertDoesntExist self.targetPageSelector, "Subject page does not exist."
      else
        # go back
        @test.assertNotVisible self.selector, "Subject page is no longer visible."


module.exports = UpdateObjectFormPageTestCase
