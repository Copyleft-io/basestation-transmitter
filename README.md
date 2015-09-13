# Basestation Transmitter
Communicates device specifics directly to Basestation.

## Getting started

 - Clone this project.
 - Run `npm install -g` 
 - Configure the below options

## Configuration
Configs can be viewed by running `basestation-transmitter configs`. Set these configs by running `basestation-transmitter set <config> <value>`.

* BASESTATION_INTERVAL - How ofen the daemon executes in milliseconds. Defaults to 5000
* BASESTATION_DEVICES_URI - URI pointing to your basestation's devices in firebase. Example: `https://basestation.firebaseio.com/devices`
* BASESTATION_SECRET (Optional) -  Secret key to authenticate to firebase. Only necessary if you have authentication configured, which is recommended. See below.

1. Set the Firebase URL. 
You can do this with the following command, replacing the example URL with your own.
`basestation-transmitter set BASESTATION_DEVICES_URI https://basestation.firebaseio.com/devices`

2. Setup security
basestation-transmitter will attempt to update devices in Firebase without authenticating if BASESTATION_SECRET is not defined. Set BASESTATION_SECRET by running 
`basestation-transmitter set BASESTATION_SECRET YOURSECRET`
Configure the Security & Rules in firebase to allow BASESTATION_SECRET access to devices. Additionally, ensure the devices "name" field is indexed. See the below example.

```
{
    "rules": {
        "devices": {
            ".indexOn" : "name",
            ".read": "auth.BASESTATION_SECRET === true",
           ".write": "auth.BASESTATION_SECRET === true"
        }
    }
}
```

## Running Basestation Transmitter
After configuring, simply run `basestation-transmitter start`


## Plugins
Plugins offer the abily to easily extend the data basestation-transmitter sends to Firebase. Simply drop a coffeescript file into the /src/plugins folder and it will be loaded to firebase.

```
module.exports = (device, interval)->
	
	setInterval (()->
	
		device.myPlugin = Math.random()
		device.save()
		
	), interval
	
```
When each plugin is called the *device* and the default *interval* is passed to it. Plugins are only called once, so if you have a repeating function, you'll need to wrap it in an interval.
Edit the device's attributes directly, and then save it with `device.save()`. Saving the device immedietly sends it to firebase.

#### [os.coffee](src/plugins/os.coffee)
Sends OS specific metrics to Basestation [Node.js's native OS integration](https://nodejs.org/api/os.html)

#### [processes.coffee](src/plugins/processes.coffee)
Only loaded for linux platforms. Identifies currently running processes and sends them to Basestation. Processes are only ones viewable by the user Basestation is running as. 

#### [installed_software.coffee](src/plugins/installed_software.coffee)
Only loaded for linux platforms. Searches the machine for installed packages and sends to Basestation. This module overrides the default interval to run only once an hour.