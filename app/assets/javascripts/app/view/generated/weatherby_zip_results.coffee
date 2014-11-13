null
###*
@class WeatherSoapAppSdk.views.WeatherbyZipResults
@extends AP.view.component.ListPage

## Model
This component is associated with model {@link WeatherSoapAppSdk.models. }.
###
class WeatherSoapAppSdk.views.WeatherbyZipResults extends AP.view.component.ListPage
  viewName: 'WeatherbyZipResults'
  baseName: 'weatherby_zip_results'
  extraClassName: 'ap-weatherby_zip_results'
  application: 'WeatherSoapApp'

  
  items: [
    
  ]
  

  rules: [
    
  ]

  
  nearest_page_ancestor_name: 'QueryWeather'
  

  
  model_name: 'WeatherByZip'
  
  
  
  
  
  
  
  
  
  
  type: 'PageComponent::ListPage'
  
  
  
  name: 'WeatherbyZipResults'
  
  
  
  title: 'WeatherByZip'
  
  
  
  authenticated_title: ''
  
  
  
  detail_title: '{{get_city_weather_by_zip}}'
  
  
  
  detail_description: '{{get_city_weather_by_zip_response}}'
  
  
  
  content: ''
  
  
  
  hyperlink_content: 'false'
  
  
  
  allow_pagination: 'false'
  
  
  
  show_list: 'false'
  
  
  
  use_current_location: 'true'
  
  
  
  zoom: '11'
  
  
  
  url: ''
  
  
  
  success_action: 'Back'
  
  
  
  success_message: ''
  
  
  
  failure_action: 'Back'
  
  
  
  failure_message: ''
  
  
  
  per_page: '25'
  
  
  
  icon: 'info-circle'
  
  
  
  position: '0'
  
  
  
  id: '8424'
  
  
  
  button_component: 'false'
  
  
  
  datasource_driven_component: 'true'
  
  
  
  full_page_component: 'true'
  
  
  
  object_form_component: 'false'
  
  
  
  object_instance_form_page_component: 'false'
  
  
  
  objectifiable_component: 'false'
  
  
  
  paginated_component: 'true'
  
  
  
  partial_page_component: 'false'
  
  
  
  titled_component: 'true'
  
  
  
  tabbed_navigation_child: 'true'
  
  
  
  authorization_rules: ''
  
  
  
  styles: ''
  
  
  
  object_definition: 'WeatherByZip'
  
  
  
  datasource: 'WeatherByZipAll'
  
  
  
  children: ''
  
  
  
  isPage: 'true'
  
  
