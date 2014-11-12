null
###*
@class AP.view.Content
@extends AP.view.View

A generic content container.  URLs, phone numbers, and email addresses may
optionally be linked automatically when `hyperlinkContent` is `true`.
###
class AP.view.Content extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-content'
  
  ###*
  @property {String}
  Renders `content`, treating it as a template.
  ###
  template: '{{ renderAttr("content") }}'
  
  ###*
  @property {String}
  Content to render.  `content` may contain template tags and/or HTML content.
  ###
  content: null
  
  ###*
  @property {Boolean}
  Automatically render links for URLs, phone numbers, and email addresses.  Use
  only for non-HTML content.
  ###
  hyperlinkContent: false
  
  ###*
  @inheritdoc
  ###
  toHtml: ->
    html = super
    if @hyperlinkContent
      # url regex:
      html = html.replace /((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/i, '<a href="$&" target="_blank">$&</a>'
      # email regex: http://www.regular-expressions.info/email.html
      html = html.replace /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, '<a href="mailto:$&">$&</a>'
      # phone number hyperlinks
      html = html.replace /\+?[\d]?[\s\.-]?\(?[\d]{3}\)?([\s\.-]?)[\d|\w]{3}\1[\d|\w]{4}/i, (match) ->
        phone = match.toLowerCase().replace(/\/|-|\./g, '')
        # linear quantization of phone letter to digit
        letters = 'abc def ghi jkl mno pqrstuv wxyz'
        qstep = 4
        phone = phone.replace /[a-z]/g, (letter) -> Math.floor(letters.indexOf(letter) / qstep) + 2
        "<a href=\"tel:#{phone}\">#{match}</a>"
    html
