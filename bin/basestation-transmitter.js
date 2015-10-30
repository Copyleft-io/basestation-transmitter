#!/usr/bin/env node
var pm2 = require('pm2'),
    nconf = require('nconf'),
    app_name = 'basestation-transmitter',
	startOptions = {
	    script: __dirname+'/../index.js',
	    name: app_name,
	    exec_mode: 'fork',
	    instances: 1,
	    max_memory_restart: '100M',
		cwd: __dirname+'/../'
	};


var help = function() {
	console.log('');
	console.log('Basestation Transmitter: Commands');
	console.log('');
	console.log('	basestation-transmitter start	- Starts basestation-transmitter');
	console.log('	basestation-transmitter stop	- Stops basestation-transmitter');
	console.log('	basestation-transmitter restart	- Restarts basestation-transmitter');
	console.log('	basestation-transmitter status	- Show the status of basestation-transmitter');
	console.log('	basestation-transmitter configs	- Shows a list of configs and their current values');
	console.log('	basestation-transmitter set <config> <value>	- Sets the supplied value');
	console.log('	basestation-transmitter help	- Shows this menu');
	console.log('');
	console.log('');
};

nconf.file({ file: __dirname+'/../config.json' });

pm2.connect(function() {

	switch (process.argv[2]) {
		case 'start':
			return pm2.start(startOptions, function(err) {
				if (err !== null) {
					console.log(err.msg);
				} else {
					console.log(app_name+' started');
				}
				return pm2.disconnect();
			});

		case 'stop':
			return pm2.stop(app_name, function(err) {
				if (err !== null) {
					console.log(err.msg);
				} else {
					console.log(app_name+' stopped');
				}
				return pm2.disconnect();
			});

		case 'restart':
			return pm2.stop(app_name, function(err) {
				if (err !== null) {
					console.log(err.msg);
					return pm2.disconnect();
				} else {
					console.log(app_name+' stopped');
                    pm2.start(startOptions, function(err) {
                        if (err !== null) {
                            console.log(err.msg);
                        } else {
                            console.log(app_name+' started');
                        }
                        return pm2.disconnect();
                    });
				}

			});

		case 'status':
			return pm2.describe(app_name, function(err, proc) {
				var found, i, len, p;
				for (i = 0, len = proc.length; i < len; i++) {
					p = proc[i];
					if (p.name === app_name && p.pid !== 0) {
						found = true;
						console.log(app_name+' is running. Process ' + p.pid);
					}
				}
				if (!found) {
					console.log(app_name+' is not running');
				}
				return pm2.disconnect();
			});


		case 'configs':
			var configs = nconf.get();
			for (var config in configs) {
			  var value = configs[config];
			   if (value !== null) {
			     console.log(config +'='+value);
			   } else {
			   	 console.log(config + ' is not set.');
			   }

			}
			return pm2.disconnect();

		case 'set':
			nconf.set(process.argv[3],process.argv[4]);
			nconf.save();
			return pm2.disconnect();

		case 'help':
			help();
			return pm2.disconnect();

		default:
			help();
			return pm2.disconnect();
	}
});
