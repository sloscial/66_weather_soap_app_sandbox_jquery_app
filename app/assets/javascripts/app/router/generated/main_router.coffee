null
###*
@class WeatherSoapAppSdk.routers.MainRouter
@extends AP.router.Router
###
class WeatherSoapAppSdk.routers.MainRouter extends AP.router.Router
  routes:
    '': 'root'
    
    'weather_by_city(/:model_name)(/:record_id)(//:query_string)': 'weather_by_city'
    
    'query_weather(/:model_name)(/:record_id)(//:query_string)': 'query_weather'
    
    'weatherby_zip_results(/:model_name)(/:record_id)(//:query_string)': 'weatherby_zip_results'
    

  root: -> @navigateToPage AP.getActiveApp().getRootViewClass()

  
  weather_by_city: (model_name, record_id, query_string) ->
    @showPage 'WeatherByCity',
      model_name: model_name
      record_id: record_id
      query_string: query_string
  
  query_weather: (model_name, record_id, query_string) ->
    @showPage 'QueryWeather',
      model_name: model_name
      record_id: record_id
      query_string: query_string
  
  weatherby_zip_results: (model_name, record_id, query_string) ->
    @showPage 'WeatherbyZipResults',
      model_name: model_name
      record_id: record_id
      query_string: query_string
  
