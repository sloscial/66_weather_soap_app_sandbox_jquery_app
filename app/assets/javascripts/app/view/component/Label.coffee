null
###*
@class AP.view.component.Label
@extends AP.view.Content

A simple content area.
###
class AP.view.component.Label extends AP.view.Content
  ###*
  @inheritdoc
  ###
  className: 'ap-content ap-label'
  
  ###*
  @inheritdoc #hyperlinkContent
  ###
  hyperlink_content: false
  
  initialize: ->
    @hyperlinkContent = (@hyperlink_content.toString() == 'true')
    super
