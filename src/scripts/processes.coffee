cp = require 'child_process'
os = require 'os'
data = false

if os.platform() == 'linux'
  data = cp.execSync "ps -H | awk '{print $1, $3, $4}'"
  data = data.toString().split '\n'

module.exports = data
