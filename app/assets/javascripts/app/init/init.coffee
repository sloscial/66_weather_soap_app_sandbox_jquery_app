# initialize app on ready
# 51077891: mobile ready is defined as the second `pagechange` event.  See issue
# comments for more information.
pageChangeCount = 0
init = _.once -> AP.getApp('WeatherSoapApp').init()

$(document).on 'pagechange', ->
  init() if pageChangeCount == 1
  pageChangeCount++
  # fallback:  init after 2 seconds if a second page change doesn't occur
  # (for Firefox)
  AP.defer 2000, -> init() if pageChangeCount == 1
