null
###*
@class AP.view.Page
@extends AP.view.View

A simple jQuery Mobile page view.  A basic page has a title, optional `items`
contained within its content body and, if specified, a footer.

A page may be a child only of `AP.Viewport`.  For example, to show a page:

    AP.Viewport.showItemByClass 'MyPageViewClass',
      pageTitle: 'My Page'
      backButton: true

[Learn more about jQuery Mobile pages.](http://view.jquerymobile.com/1.3.1/dist/demos/widgets/pages/)
###
class AP.view.Page extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-page'
  
  ###*
  @property {String}
  The `id` HTML attribute for this page's element.  If one is not specified it
  will be generated automatically, as an `id` is required by jQuery Mobile.
  ###
  id: ''
  
  ###*
  @property {String}
  An optional title for this page, dispalyed in the header.
  ###
  pageTitle: ''
  
  ###*
  @property {Boolean}
  If `true`, a back button will be shown in the header.  The previously active
  page in `AP.Viewport` is automatically associated with the back button.
  ###
  backButton: false
  
  ###*
  @property {String}
  Text to show in the back button.
  ###
  backButtonText: 'Back'
  
  ###*
  @property {String}
  `href` property of the back button.  Override if the back button must link to
  another website.
  ###
  backButtonHref: '#'
  
  ###*
  @property {String/AP.view.Page}
  A page view instance or fully qualified page view class name to be shown when
  the user activates the back button.
  ###
  previousPage: ''
  
  ###*
  @property {Object}
  HTML attributes to output into this page view's element.
  ###
  attributes:
    'data-role': 'page'
  
  ###*
  @property {String}
  Template for this page's header.
  ###
  headerTemplate: '''
    <div data-role="header" data-position="fixed" data-tap-toggle="false" data-hide-during-focus="">
      {% if (backButton) { %}
        <a data-role="button" data-icon="arrow-l" class="ap-backbutton" href="{%- backButtonHref %}">{%- backButtonText %}</a>
      {% } %}
      <h1>{{ renderAttr("pageTitle") }}</h1>
    </div>
  '''
  
  ###*
  @property {String}
  Template for this page's content body.
  ###
  contentTemplate: '<div data-role="content"></div>'
  
  ###*
  @property {String}
  Template for this page's footer.
  ###
  footerTemplate: ''
  
  ###*
  @inheritdoc
  ###
  events:
    'click .ap-backbutton': 'onBackAction'
  
  ###*
  Sets the template to a concatenation of header, content, and footer templates.
  ###
  initialize: ->
    @id = @uuid() if !@id
    @$el.attr 'id', @id
    super
    # don't render on record change, because jQuery mobile cannot handle the
    # graceful re-rendering of pages
    # TODO:  solve this
    @stopListening(@getRecord()) if @getRecord()
    @initializeHeader()
    if !@previousPage
      @previousPage = AP.Viewport?.getCurrentItem()
  
  ###*
  Override to customize header.
  ###
  initializeHeader: ->
    # pass
  
  ###*
  Executed when user activates the back button.  Override to change back
  button behavior.
  ###
  onBackAction: (e) ->
    e.preventDefault()
    @goBack()
  
  ###*
  Generates a unique ID.
  @return {String} a unique ID
  ###
  uuid: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random() * 16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)
  
  ###*
  @return {Function} compiles the {@link #template} string, if set, and returns
  a template function.  If `template` does not exist on this page,
  `headerTemplate`, `contentTemplate`, and `footerTemplate` are concatenated to
  create the template string.
  ###
  getTemplate: ->
    _.template(@template or "#{@headerTemplate}#{@contentTemplate}#{@footerTemplate}")
  
  ###*
  Shows the page using underlaying jQuery Mobile `changePage` method.
  @param {Object} options optional configuration object passed to jQuery Mobile
  `changePage` method.
  ###
  _show: (options) -> $.mobile.changePage "##{@id}", options
  
  ###*
  @inheritdoc
  ###
  append: (el) ->
    @$el.find('[data-role="content"]').append el
  
  ###*
  @private
  Appends the element to this view's inner content element.
  @param {Element} el the element to append to this view's inner content element
  ###
  appendHeader: (el) ->
    @$el.find('[data-role="header"]').append el
  
  ###*
  Shows the view {@link #previousPage} in the viewport and removes this
  page view after a short delay.
  @return {AP.view.Page} this page view instance _if_ `previousPage` exists and
  the current page is successfully removed from the viewport
  ###
  goBack: ->
    if @previousPage
      AP.getActiveApp().router.navigateToPage @previousPage
      AP.Viewport.remove @
