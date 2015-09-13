cp = require 'child_process'
os = require 'os'
merge = require 'merge'

module.exports = (device, interval)->
	
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
  
	), interval