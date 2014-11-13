null
###*
@class AP.view.Dialog
@extends AP.view.Page

A simple page with a back button.  By default, a dialog's back button text
is "Close".
###
class AP.view.Dialog extends AP.view.Page
  ###*
  @inheritdoc
  ###
  className: 'ap-page ap-dialog'
    
  ###*
  @inheritdoc
  ###
  backButton: true
  
  ###*
  @inheritdoc
  ###
  backButtonText: 'Close'
