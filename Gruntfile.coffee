
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

  grunt.registerTask 'build', [ 'electron' ]
