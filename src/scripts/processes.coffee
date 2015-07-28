cp = require 'child_process'
os = require 'os'
data = false

if os.platform() == 'linux'
  data = []
  ps = cp.execSync "ps -Ao pid,fname,%cpu,%mem --sort %cpu,%mem --no-headers | tail -30  | awk '{print $1, $2, $3, $4}'"
  for row in ps.toString().split '\n'
    metrics = row.split ' '
    if metrics[1]?
      data.push {
        pid: metrics[0],
        process: metrics[1],
        percent_cpu: metrics[2],
        percent_mem: metrics[3]
      }

module.exports = data
