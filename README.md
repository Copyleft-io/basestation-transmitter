# Basestation Transmitter
Communicates device specifics directly to Basestation.

## Getting started

 - Clone this project.
 - Run `npm install` 
 - Configure the below options

## Configuration
Configuration can be done one of two ways; 1: editing the src/config.json file or 2: defining the configs in environment variables. If environment variables are defined, they will take precedence over any defined configuration in the config.json file.

BASESTATION_INTERVAL - How ofen the daemon executes in milliseconds. Defaults to 5000
BASESTATION_DEVICES_URI - URI pointing to your basestation's devices in firebase. Example: `https://basestation.firebaseio.com/devices`
BASESTATION_SECRET (Optional) -  Secret key to authenticate to firebase. Only necessary if you have authentication configured, which is recommended. See below.

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

## Additional Notes
The metrics transmitted to Basestation are from Node's native OS integration, here: https://nodejs.org/api/os.html
