casper = require('casper').create({colorizerType: 'Dummy'})
utils = require('utils')
ListPageTestCase = require('./test/lib/list_page.coffee')


module.exports =
  class WeatherbyZipResultsTestCase extends ListPageTestCase
    viewName: 'WeatherbyZipResults'
    baseName: 'weatherby_zip_results'
    selector: '.ap-weatherby_zip_results'
    application: 'WeatherSoapApp'

    
    model_name: 'GetCityWeatherByZip'
    

    
    ancestorPage:
      viewName: 'QueryWeather'
      baseName: 'query_weather'
      selector: '.ap-query_weather'
      
      
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
      
      
      
      object_definition: 'GetCityWeatherByZip'
      
      
      
      page: 'WeatherbyZipResults'
      
      
      
      children: ''
      
      
      
      isPage: 'true'
      
      
    

    component:
      items: []
      childrenTitles: []
      childrenSelectors: []
      
      
      type: 'PageComponent::ListPage'
      
      
      
      name: 'WeatherbyZipResults'
      
      
      
      title: 'WeatherByZip'
      
      
      
      authenticated_title: ''
      
      
      
      detail_title: '{{zip_code}}'
      
      
      
      detail_description: '{{get_city_weather_by_zip_result}}'
      
      
      
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
      
      
      
      object_definition: 'GetCityWeatherByZip'
      
      
      
      datasource: 'GetCityWeatherByZipAll'
      
      
      
      children: ''
      
      
      
      isPage: 'true'
      
      
