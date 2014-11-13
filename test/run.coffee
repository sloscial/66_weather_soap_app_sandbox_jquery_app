testUrl = './test/index.html'
casper = require('casper').create({colorizerType: 'Dummy'})
startTime = null


casper.start testUrl, ->
  startTime = Date.now()


tests =
  
  weather_by_city: new (require('./test/cases/weather_by_city.coffee'))(casper, testUrl)
  
  query_weather: new (require('./test/cases/query_weather.coffee'))(casper, testUrl)
  
  weatherby_zip_results: new (require('./test/cases/weatherby_zip_results.coffee'))(casper, testUrl)
  

test.run() for name, test of tests


casper.run ->
  duration = (Date.now() - startTime) / 1000
  @test.info "Completed all tests in #{duration.toFixed(2)}s"
  @test.info ''
  @exit()
