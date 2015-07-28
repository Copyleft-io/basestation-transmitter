#
#module.exports = (grunt) ->
#  grunt.initConfig nwjs:
#    options:
#      version: '0.12.0'
#      buildDir: './build'
#      platforms: [
#        'osx'
#        'win'
#        'linux'
#      ]
#    src: ['./**', '!./build/**', '!./cache/**']
#
#  grunt.loadNpmTasks 'grunt-nw-builder'
#  grunt.registerTask 'default', [ 'nwjs' ]

#module.exports = (grunt) ->

module.exports = (grunt) ->

  require('load-grunt-tasks') grunt

  grunt.initConfig electron:
    osxBuild: options:
      name: 'basestation-transmitter'
      dir: './'
      out: 'dist'
      version: '0.30.1'
      platform: 'darwin'
      arch: 'x64'
      overwrite: true

    winBuild: options:
      name: 'basestation-transmitter'
      dir: './'
      out: 'dist'
      version: '0.30.1'
      platform: 'win32'
      arch: 'x64'
      overwrite: true

    linuxBuild: options:
      name: 'basestation-transmitter'
      dir: './'
      out: 'dist'
      version: '0.30.1'
      platform: 'linux'
      arch: 'x64'
      overwrite: true

  grunt.registerTask 'default', [ 'electron' ]




#  grunt.loadNpmTasks('grunt-electron-installer')
#
#  'create-windows-installer': {
#    appDirectory: '/tmp/build/my-app',
#    outputDirectory: '/tmp/build/installer',
#    authors: 'My App Inc.',
#    exe: 'myapp.exe'
#  }