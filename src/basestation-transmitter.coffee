os = require 'os'
Firebase = require 'firebase'
FirebaseTokenGenerator = require 'firebase-token-generator'
merge = require 'merge'
config = require './config.json'
fs = require 'fs'

interval = process.env.BASESTATION_INTERVAL or config.BASESTATION_INTERVAL or 5000
firebase_uri = process.env.BASESTATION_DEVICES_URI or config.BASESTATION_DEVICES_URI
secret = process.env.BASESTATION_SECRET or config.BASESTATION_SECRET

devices = new Firebase firebase_uri

unless config.BASESTATION_INTERVAL? or process.env.BASESTATION_INTERVAL?
  console.log "[INFO] BASESTATION_INTERVAL not set. Defaulting to #{interval}"

unless secret?
  console.warn "[WARN] BASESTATION_SECRET not set. Not attempting to authenticate"

unless firebase_uri?
  console.error "[ERROR] BASESTATION_DEVICES_URI not set."
  process.exit()

if secret?
  console.info "basestation: Attempting to authenticate using BASESTATION_SECRET"

  tokenGenerator = new FirebaseTokenGenerator secret
  token = tokenGenerator.createToken { "uid": "custom:BASESTATION_SECRET", "BASESTATION_SECRET": true }
  devices.authWithCustomToken token, (error, authData) ->
    if error
      return console.error '[ERROR] Basestation: Login Failed!', error
    else
      return console.info '[INFO] Basestation: Authenticated successfully'

save = (ref, device) ->

  ### Include Plugins ###
  for script in fs.readdirSync('./src/scripts')
    data = require "./scripts/#{script}"
    if data?
      device[script.replace('.coffee', '')] = data

  ref.set merge device, {
    name: os.hostname()
    platform: os.platform()
    release: os.release()
    arch: os.arch()
    type: os.type()
    totalmem: os.totalmem()
    freemem: os.freemem()
    uptime: os.uptime()
    loadavg: os.loadavg()
    cpus: os.cpus()
    network: os.networkInterfaces()
  }

devices.orderByChild('name').equalTo(os.hostname()).once 'value', (snapshot) ->

  if snapshot.exists()
    console.log '[INFO] Device found'
    device = snapshot.val()
    key = Object.keys(device)[0]
    setInterval save, interval, snapshot.ref().child(key), device[key]

  unless snapshot.exists()
    console.log '[INFO] Could not find device. Creating a new one'
    ref = devices.push {}
    setInterval save, interval, ref, {}
