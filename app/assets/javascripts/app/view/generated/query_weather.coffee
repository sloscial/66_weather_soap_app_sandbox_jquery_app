null
###*
@class WeatherSoapAppSdk.views.QueryWeather
@extends AP.view.component.QueryObjectFormPage

## Model
This component is associated with model {@link WeatherSoapAppSdk.models. }.
###
class WeatherSoapAppSdk.views.QueryWeather extends AP.view.component.QueryObjectFormPage
  viewName: 'QueryWeather'
  baseName: 'query_weather'
  extraClassName: 'ap-query_weather'
  application: 'WeatherSoapApp'

  
  items: [
    
  ]
  

  rules: [
    
  ]

  
  nearest_page_ancestor_name: 'WeatherByCity'
  

  
  model_name: 'WeatherByZip'
  
  
  
  formFields: {"zip_code":{"name":"zip_code","object_definition":{"name":"WeatherByZip"},"label":"ZIP Code"}}
  
  
  
  
  
  
  
  
  type: 'PageComponent::QueryObjectFormPage'
  
  
  
  name: 'QueryWeather'
  
  
  
  title: 'Look by Zip'
  
  
  
  authenticated_title: ''
  
  
  
  detail_title: ''
  
  
  
  detail_description: ''
  
  
  
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
  
  
  
  icon: 'bar-chart-o'
  
  
  
  position: '0'
  
  
  
  id: '8423'
  
  
  
  button_component: 'false'
  
  
  
  datasource_driven_component: 'false'
  
  
  
  full_page_component: 'true'
  
  
  
  object_form_component: 'true'
  
  
  
  object_instance_form_page_component: 'false'
  
  
  
  objectifiable_component: 'false'
  
  
  
  paginated_component: 'false'
  
  
  
  partial_page_component: 'false'
  
  
  
  titled_component: 'true'
  
  
  
  tabbed_navigation_child: 'true'
  
  
  
  authorization_rules: ''
  
  
  
  field_definition_maps: ''
  
  
  
  styles: ''
  
  
  
  object_definition: 'WeatherByZip'
  
  
  
  page: 'WeatherbyZipResults'
  
  
  
  children: ''
  
  
  
  isPage: 'true'
  
  
