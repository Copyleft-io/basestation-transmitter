os                      = require 'os'
Firebase                = require 'firebase'
FirebaseTokenGenerator  = require 'firebase-token-generator'
fs                      = require 'fs'
path                    = require 'path'
Device                  = require path.resolve 'src', 'lib', 'Device.coffee'

nconf = require 'nconf'
nconf.file file: 'config.json'

devices = new Firebase nconf.get('BASESTATION_DEVICES_URI')

unless nconf.get('BASESTATION_SECRET')?
  console.warn "[WARN] BASESTATION_SECRET not set. Not attempting to authenticate"

unless nconf.get('BASESTATION_DEVICES_URI')?
  console.error "[ERROR] BASESTATION_DEVICES_URI not set."
  process.exit()

if nconf.get('BASESTATION_SECRET')?
  console.info "basestation: Attempting to authenticate using BASESTATION_SECRET"

  tokenGenerator = new FirebaseTokenGenerator nconf.get('BASESTATION_SECRET')
  token = tokenGenerator.createToken { "uid": "custom:BASESTATION_SECRET", "BASESTATION_SECRET": true }
  devices.authWithCustomToken token, (error) ->
    if error
      return console.error '[ERROR] Basestation: Login Failed!', error
    else
      return console.info '[INFO] Basestation: Authenticated successfully'

loadPlugins = (device)->
  ### Include Plugins ###
  plugins = fs.readdirSync("#{__dirname}/plugins").sort()

  for plugin in nconf.get('plugins')
    console.log "Loading #{plugin}"

    try
      script = require path.resolve 'src', 'plugins', plugin
      unless typeof script is 'function'
        return console.warning "Expected #{file} to assign a function to module.exports, got #{typeof script} instead"
      script device, nconf

    catch error
      console.error "Unable to load #{file}: #{error.stack}"
      process.exit(1)

devices.orderByChild('name').equalTo(os.hostname()).once 'value', (snapshot) ->

  if snapshot.exists()
    console.log '[INFO] Device found'
    existing_device = snapshot.val()
    id = Object.keys(snapshot.val())[0]
    device = new Device snapshot.ref().child(id), existing_device[id]

  else
    console.log '[INFO] Could not find device. Creating a new one'
    ref = devices.push {}
    device = new Device ref

  loadPlugins device
