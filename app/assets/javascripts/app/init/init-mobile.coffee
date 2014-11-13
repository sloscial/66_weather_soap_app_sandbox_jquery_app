$(document).on 'mobileinit', ->
  # set jquery mobile defaults
  $.extend $.mobile,
    linkBindingEnabled: false
    pushStateEnabled: false
    hashListeningEnabled: false
    ajaxEnabled: false
    defaultPageTransition: 'none'
    'buttonMarkup.hoverDelay': 50
