dotenv = require('dotenv')

# generate file name sfor compiled production assets
nowStamp = Date.now()
productionAssetNames =
  css: "application-#{nowStamp}.css"
  js: "application-#{nowStamp}.js"

# generate file configurations for asset compilation tasks
minifyFiles = {}
uglifyFiles = {}
minifyFiles["public/#{productionAssetNames.css}"] = ['public/application.css']
uglifyFiles["public/#{productionAssetNames.js}"] = ['public/application.js']

module.exports = (grunt) ->
  # load environment
  dotenv.load()
  
  # load package JSON
  pkg = grunt.file.readJSON 'package.json'
  
  # initialize grunt
  grunt.initConfig
    pkg: pkg
    clean:
      javascripts: ['app/assets/javascripts/app/**/*.js', 'app/assets/javascripts/sdk/*.js']
      stylesheets: ['app/assets/stylesheets/all.css', 'app/assets/stylesheets/app/styles.css']
    copy:
      images:
        expand: true
        cwd: 'app/assets/images/'
        src: ['**']
        dest: 'public/'
    sass:
      css:
        options:
          compass: true
          require: ['compass']
          loadPath: ['app/assets/stylesheets/app/theme/', 'app/assets/stylesheets/lib/']
        files:
          'app/assets/stylesheets/all.css': ['app/assets/stylesheets/app/theme/styles.sass', 'app/assets/stylesheets/app/theme_components/*.sass', 'custom/stylesheets/**/*.sass']
    coffee:
      app:
        expand: true
        cwd: 'app/assets/javascripts/app/'
        src: ['**/*.coffee']
        dest: 'app/assets/javascripts/app/'
        ext: '.js'
      custom:
        expand: true
        src: ['custom/javascripts/**/*.coffee']
        ext: '.js'
    concat:
      css:
        src: [
          'app/assets/stylesheets/jquery.mobile-1.4.2.css'
          'app/assets/stylesheets/offline.css'
          'app/assets/stylesheets/nv.d3.css'
          'app/assets/stylesheets/all.css'
          'custom/stylesheets/**/*.css'
        ]
        dest: 'public/application.css'
      js:
        src: [
          # libraries
          'app/assets/javascripts/lib/jquery/jquery-1.9.1.js'
          'app/assets/javascripts/lib/underscore/underscore.js'
          'app/assets/javascripts/lib/backbone/backbone.js'
          'app/assets/javascripts/lib/q/q.js'
          'app/assets/javascripts/lib/large-local-storage/large-local-storage.js'
          'app/assets/javascripts/lib/offline/offline.js'
          'node_modules/d3/d3.js'
          'app/assets/javascripts/lib/nvd3/nv.d3.js'
          'app/assets/javascripts/lib/sdk/ap_sdk.js'
          # jquery mobile init
          'app/assets/javascripts/app/init/init-mobile.js'
          'app/assets/javascripts/lib/jquery-mobile/jquery.mobile-1.4.2.js'
          # ap / application
          'app/assets/javascripts/app/ap/*.js'
          'app/assets/javascripts/app/application/*.js'
          # controllers
          'app/assets/javascripts/app/controller/Controller.js'
          'app/assets/javascripts/app/controller/Authentication.js'
          'app/assets/javascripts/app/controller/component/*.js'
          # routers
          'app/assets/javascripts/app/router/router.js'
          'app/assets/javascripts/app/router/generated/main_router.js'
          # views
          'app/assets/javascripts/app/view/View.js'
          'app/assets/javascripts/app/view/DataView.js'
          'app/assets/javascripts/app/view/DataViewItem.js'
          'app/assets/javascripts/app/view/Page.js'
          'app/assets/javascripts/app/view/Dialog.js'
          'app/assets/javascripts/app/view/Field.js'
          'app/assets/javascripts/app/view/Form.js'
          'app/assets/javascripts/app/view/ModelForm.js'
          'app/assets/javascripts/app/view/Button.js'
          'app/assets/javascripts/app/view/Carousel.js'
          'app/assets/javascripts/app/view/CarouselItem.js'
          'app/assets/javascripts/app/view/Chart.js'
          'app/assets/javascripts/app/view/Content.js'
          'app/assets/javascripts/app/view/HorizontalRule.js'
          'app/assets/javascripts/app/view/Image.js'
          'app/assets/javascripts/app/view/List.js'
          'app/assets/javascripts/app/view/ListItem.js'
          'app/assets/javascripts/app/view/Map.js'
          'app/assets/javascripts/app/view/MapItem.js'
          'app/assets/javascripts/app/view/Viewport.js'
          'app/assets/javascripts/app/view/component/*.js'
          # generated views
          'app/assets/javascripts/app/view/generated/*.js'
          # custom
          'custom/javascripts/**/*.js'
          # app init
          'app/assets/javascripts/app/init/init.js'
        ]
        dest: 'public/application.js'
    cssmin:
      app:
        files: minifyFiles
    uglify:
      app:
        options:
          mangle: false
        files: uglifyFiles
    compress:
      css:
        options:
          mode: 'gzip'
        expand: true
        src: ["public/#{productionAssetNames.css}"]
        ext: '.css.gzip'
      js:
        options:
          mode: 'gzip'
        expand: true
        src: ["public/#{productionAssetNames.js}"]
        ext: '.js.gzip'
    template:
      app:
        src: 'templates/index.html.mustache'
        dest: 'public/index.html'
        variables:
          title: pkg.name
          css: productionAssetNames.css
          js: productionAssetNames.js
      s3:
        src: 'templates/index.s3.html.mustache'
        dest: 'public/index.s3.html'
        variables:
          title: pkg.name
          css: productionAssetNames.css
          js: productionAssetNames.js
    manifest:
      app:
        options:
          basePath: 'public/'
          #timestamp: false
          hash: true
        src: [
          'index.html',
          '*.png',
          '*.jpg',
          '*.gif',
          '*.svg',
          'images/*',
          'default/pictos/*.png',
          "#{productionAssetNames.js}",
          "#{productionAssetNames.css}"
        ]
        dest: 'public/cache.manifest'
      s3:
        options:
          basePath: 'public/'
          #timestamp: false
          hash: true
        src: [
          'index.s3.html',
          '*.png',
          '*.jpg',
          '*.gif',
          '*.svg',
          'images/*',
          'default/pictos/*.png',
          "#{productionAssetNames.js}.gzip",
          "#{productionAssetNames.css}.gzip"
        ]
        dest: 'public/cache.s3.manifest'
    casperjs:
      files: ['test/run.coffee']
    watch:
      sass:
        files: ['app/assets/stylesheets/**/*.sass', 'custom/stylesheets/**/*.sass']
        tasks: ['compile-css', 'clean']
      coffee:
        files: ['app/assets/javascripts/**/*.coffee', 'custom/javascripts/**/*.coffee']
        tasks: ['compile-js', 'clean']
    aws_s3:
      # production
      clean_production:
        action: 'delete'
        dest: '/'
        options:
          accessKeyId: process.env.PRODUCTION_AWS_KEY_ID
          secretAccessKey: process.env.PRODUCTION_AWS_SECRET_KEY
          bucket: process.env.PRODUCTION_AWS_S3_BUCKET
      public_production:
        action: 'upload'
        options:
          accessKeyId: process.env.PRODUCTION_AWS_KEY_ID
          secretAccessKey: process.env.PRODUCTION_AWS_SECRET_KEY
          bucket: process.env.PRODUCTION_AWS_S3_BUCKET
        files: [
          expand: true
          cwd: 'public'
          src: '**'
        ,
          expand: true
          cwd: 'public'
          src: '**.css.gzip'
          params:
            ContentType: 'text/css'
            ContentEncoding: 'gzip'
        ,
          expand: true
          cwd: 'public'
          src: '**.js.gzip'
          params:
            ContentType: 'application/javascript'
            ContentEncoding: 'gzip'
        ]
  
  # load required grunt tasks
  grunt.loadNpmTasks 'grunt-templater'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-manifest'
  grunt.loadNpmTasks 'grunt-casperjs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-aws-s3'
  
  # define custom tasks
  grunt.registerTask 'compile-css', ['sass', 'concat:css']
  grunt.registerTask 'compile-js', ['coffee', 'concat:js']
  grunt.registerTask 'compile', ['clean', 'compile-css', 'compile-js']
  grunt.registerTask 'build', ['compile', 'cssmin', 'uglify', 'compress', 'clean', 'copy', 'template', 'manifest']
  grunt.registerTask 'test', ['casperjs']
  grunt.registerTask 'deploy:production', ['aws_s3:clean_production', 'aws_s3:public_production']
