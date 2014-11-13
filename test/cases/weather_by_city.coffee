casper = require('casper').create({colorizerType: 'Dummy'})
utils = require('utils')
TabbedNavigationTestCase = require('./test/lib/tabbed_navigation.coffee')


module.exports =
  class WeatherByCityTestCase extends TabbedNavigationTestCase
    viewName: 'WeatherByCity'
    baseName: 'weather_by_city'
    selector: '.ap-weather_by_city'
    application: 'WeatherSoapApp'

    

    

    component:
      items: ['QueryWeather',]
      childrenTitles: ['Look by Zip',]
      childrenSelectors: ['.ap-query_weather',]
      
      
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
      
      
