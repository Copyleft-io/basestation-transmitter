cp = require 'child_process'
os = require 'os'

listInstalledSoftware = (device)->
	device.installed_software = []
	
	ps = cp.execSync "dpkg --get-selections | awk '{print $1}'"
	for row in ps.toString().split '\n'
	 device.installed_software.push row
	device.save()

module.exports = (device)->
	return unless os.platform() == 'linux'
	
	listInstalledSoftware device
	setInterval listInstalledSoftware, 3600000, device
