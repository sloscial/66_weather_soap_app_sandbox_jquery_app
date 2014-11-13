casper = require('casper').create({colorizerType: 'Dummy'})
utils = require('utils')
QueryObjectFormPageTestCase = require('./test/lib/query_object_form_page.coffee')


module.exports =
  class QueryWeatherTestCase extends QueryObjectFormPageTestCase
    viewName: 'QueryWeather'
    baseName: 'query_weather'
    selector: '.ap-query_weather'
    application: 'WeatherSoapApp'

    
    model_name: 'WeatherByZip'
    

    
    ancestorPage:
      viewName: 'WeatherByCity'
      baseName: 'weather_by_city'
      selector: '.ap-weather_by_city'
      
      
      type: 'PageComponent::TabbedNavigation'
      
      
      
      name: 'WeatherByCity'
      
      
      
      title: ''
      
      
      
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
      
      
      
      icon: 'info-circle'
      
      
      
      position: '0'
      
      
      
      id: '8422'
      
      
      
      button_component: 'false'
      
      
      
      datasource_driven_component: 'false'
      
      
      
      full_page_component: 'false'
      
      
      
      object_form_component: 'false'
      
      
      
      object_instance_form_page_component: 'false'
      
      
      
      objectifiable_component: 'false'
      
      
      
      paginated_component: 'false'
      
      
      
      partial_page_component: 'false'
      
      
      
      titled_component: 'false'
      
      
      
      tabbed_navigation_child: 'false'
      
      
      
      authorization_rules: ''
      
      
      
      styles: ''
      
      
      
      children: ''
      
      
      
      isPage: 'false'
      
      
    

    component:
      items: []
      childrenTitles: []
      childrenSelectors: []
      
      
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
      
      
