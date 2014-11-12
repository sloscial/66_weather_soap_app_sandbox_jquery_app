null
###*
@class AP.view.component.UrlButton
@extends AP.view.Button

Opens the specified URL on click.
###
class AP.view.component.UrlButton extends AP.view.Button
  className: 'ap-button ap-urlbutton'
  target: '_blank'
  preventDefaultClickAction: false
