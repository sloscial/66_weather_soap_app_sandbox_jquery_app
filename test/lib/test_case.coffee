###*
@class CasperTestCase
Base class for Casper UI test cases.  `CasperTestCase` provides conveniences
for UI testing, as well as basic existence verification for all test cases.

**Note**:  this class is intended for subclassing and should not be
instantiated directly.

Initializing and running a test case is easy:

    testUrl = './index.html'
    casper = require('casper').create({colorizerType: 'Dummy'})
    test = new MainPageTestCase(casper, testUrl)
    test.run()
    casper.run()

See the test runner, `run.coffee`.
###
class CasperTestCase
  ###*
  @property {String}
  URL of the test application to load into Casper.
  ###
  testUrl: null
  
  ###*
  @property {String}
  Name of the view class to test.
  ###
  viewName: null
  
  ###*
  @property {String}
  Underscore-formatted name of the view class.
  ###
  baseName: null
  
  ###*
  @property {String}
  CSS selector for the rendered view class.
  ###
  selector: null
  
  ###*
  @property {String}
  Application name.
  ###
  application: null
  
  ###*
  @property
  CasperJS instance.  Pass an initiaized casper instance at
  instantiation time.
  ###
  casper: null
  
  ###*
  @property {Number}
  Time at which this test began, in ms from epoch.  Used to track
  test duration.
  ###
  startTime: null
  
  ###*
  @property {String}
  Name of the view class of the page on which the tested view component is
  present.  If the tested component is itself a page, `pageViewName` may be
  the same as `viewName`.
  ###
  pageViewName: null
  
  ###*
  @property
  ID of a datasource associated with the ancestor page.
  ###
  datasourceId: null
  
  ###*
  @property
  ID of a model associated with the ancestor page.
  ###
  objectDefId: null
  
  ###*
  @property {Object}
  Hash of key/values describing the page on which the tested view component is
  present.  If the test component is itself a page, `ancestorPage` may be the
  same as `component`.
  ###
  ancestorPage: null
  
  ###*
  @property {Object}
  Hash of key/values describing the tested view component.
  ###
  component: null
    
  ###*
  @property {Boolean}
  Automatically execute the `verifyExists` test?
  ###
  autoVerifyExists: true
  
  constructor: -> @initialize.apply @, arguments
  
  initialize: (casper, testUrl) ->
    @casper = casper
    @testUrl = testUrl
    @pageViewName = @ancestorPage?.viewName or @viewName
  
  run: ->
    @before @
    @test @
    @after @
  
  ###*
  Executed before the test run.  By default, opens the test URL (specified at
  instantiation), navigates to the page on which the tested component appears,
  and verifies existence of the tested component on its expected ancestor page.
  @param {CasperTestCase} self this test case instance
  ###
  before: (self) ->
    @casper.then ->
      self.startTime = Date.now()
      @test.info "-----> Begin tests for '#{self.viewName}'"
    @navigateTo()
    @verifyExists() if @autoVerifyExists
  
  ###*
  Executed the test(s).
  @param {CasperTestCase} self this test case instance
  ###
  test: (self) ->
    # pass
  
  ###*
  Executed after the test run.
  @param {CasperTestCase} self this test case instance
  ###
  after: (self) ->
    @casper.then ->
      duration = (Date.now() - self.startTime) / 1000
      @test.info "Completed '#{self.viewName}' tests in #{duration.toFixed(2)}s"
      @test.info '                    .'
      @test.info '                    .'
  
  ###*
  Navigates to `pageViewClass`, the page on which the tested component
  appears, or the compnent itself if the component is a page.  If the page
  specifies a datasource of object definition, an instance of the associated
  model, taken from the mock server, is used to instantiate the page.
  ###
  navigateTo: ->
    self = @
    baseName = if (@component.isPage == 'true') then @baseName else (@ancestorPage?.baseName or @baseName)
    modelName = if (@component.isPage == 'true') and @model_name then @model_name else (@ancestorPage?.object_definition or @model_name)
    hash = "#{baseName}"
    hash = "#{hash}/#{modelName}/#{modelName}-0" if modelName?
    url = "#{self.testUrl}##{hash}"
    @casper.then ->
      alreadyThere = @getCurrentUrl().indexOf(hash, this.length - hash.length) != -1
      if !alreadyThere
        @thenOpen url, ->
          @test.info "Navigated to '#{self.pageViewName}': #{url}"
  
  ###*
  A simple Casper test that verifies the tested component exists in its
  expected parent page.
  ###
  verifyExists: ->
    self = @
    selector = if @ancestorPage and (@ancestorPage.selector != @selector) and !(@component.isPage == 'true') then "#{@ancestorPage.selector} #{@selector}" else @selector
    @casper.waitForSelector selector, ->
      @test.assertExists selector, "Component exists on the '#{self.pageViewName}' page"
  
  ###*
  Sets the value of this test case's `targetPageSelector` property to a CSS
  selector for the tested component's target page.  Examples of components
  that may have target pages include list and page button.
  ###
  getTargetPageSelector: ->
    if @component.page or @component.success_page
      self = @
      @casper.then ->
        self.targetPageSelector = '.ap-' + @evaluate(((targetPageId) ->
          pageClass = AP.getActiveApp().getView(targetPageId)
          pageClass::baseName
        ), self.component.page or self.component.success_page)
  
  ###*
  Sets the value of this test cases `instanceData` property to a key/value
  hash of values appropriate for filling a form on the ancestor page.  Form
  data is generated by a mock server utility method using the model class
  associated with the ancestor page.
  ###
  generateRandomFormData: ->
    self = @
    datasource = @ancestorPage?.datasource or @component.datasource
    objectDefinition = @ancestorPage?.object_definition or @component.object_definition
    @casper.then ->
      @test.info "Generating random form data"
      # generate some random data for the form
      # the resulting object saved to the mock server should reflect
      # the generated data
      self.instanceData = @evaluate(((pageViewName, datasourceId, objectDefId) ->
        app = AP.getActiveApp()
        if datasourceId
          collectionClass = app.getCollection datasourceId
          modelClass = collectionClass::model
        if objectDefId
          modelClass = app.getModel objectDefId
        AP.utility.MockServer.Models.generateRandomInstanceDataFor modelClass
      ), self.pageViewName, datasource, objectDefinition)
  
  ###*
  Fills a form appearing on the page with values in this test cases'
  `instanceData` property.  Sets this test case's `filledData` property to a
  hash of names and values of fields filled, since filled fields may be a
  subset of `instanceData`.
  ###
  fillForm: ->
    self = @
    # fill form with generated data and keep track of the fields filled
    @casper.then ->
      @test.info "Filling form"
      self.filledData = @evaluate(((selector, data) ->
        data = JSON.parse(data)
        filledData = []
        $("#{selector} form :input").each (i, field) ->
          name = $(field).attr('name')
          value = data[name]
          if data[name]?
            filledData.push([name, value])
            if $(field).is('[type="checkbox"]')
              $(field).attr('checked', !!value)
            else
              $(field).val(value)
        JSON.stringify(filledData)
      ), self.selector, JSON.stringify(self.instanceData))
      self.filledData = JSON.parse(self.filledData)
  
  ###*
  Submits a form on the page by clicking the save button.
  ###
  submitForm: ->
    self = @
    # submit
    @casper.then ->
      @test.info "Submitting form..."
      @click "#{self.selector} .ap-submit-button button"
  
  ###*
  Gets the record data from a model instance in the datastore associated with
  the ancestor page and saves it into this test case's `savedInstanceData`
  property.  Used to verify that submitted data matches data saved to the mock
  backend datastore.
  @param {String} instanceMethod specifies which instance to get from the mock
  datastore:  `last` or `first`; defaults to `last`
  ###
  getSavedInstanceData: (instanceMethod) ->
    self = @
    instanceMethod ?= 'last'
    datasource = @ancestorPage?.datasource or @component.datasource
    objectDefinition = @ancestorPage?.object_definition or @component.object_definition
    @casper.then ->
      self.savedInstanceData = JSON.parse @evaluate(((pageViewName, datasourceId, objectDefId, instanceMethod) ->
        app = AP.getActiveApp()
        if datasourceId
          collectionClass = app.getCollection datasourceId
          modelClass = collectionClass::model
        if objectDefId
          modelClass = app.getModel objectDefId
          collectionClass = app.getCollection "#{modelClass.name}All"
        collection = app.mockServer.getOrCreateCollectionInstanceFor(collectionClass) if collectionClass
        JSON.stringify(collection?[instanceMethod]?()?.attributes)
      ), self.pageViewName, datasource, objectDefinition, instanceMethod)


module.exports = CasperTestCase
