cp = require 'child_process'
os = require 'os'

module.exports = (device, nconf) ->
	setInterval (()->

		device.name = os.hostname()
		device.platform = os.platform()
		device.release = os.release()
		device.arch = os.arch()
		device.type = os.type()
		device.totalmem = os.totalmem()
		device.freemem = os.freemem()
		device.uptime = os.uptime()
		device.loadavg = os.loadavg()
		device.cpus = os.cpus()
		device.network = os.networkInterfaces()

		device.save()

	), nconf.get 'BASESTATION_INTERVAL'
