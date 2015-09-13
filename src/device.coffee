
merge = require 'merge'
us = require 'underscore'


class Device
	constructor: (@firebase_ref, elements = {})->
		@omitted_elements = ['omitted_elements','firebase_ref','save']
		merge @, elements
		
	save: ()->
		device = us.clone @
		for element in @omitted_elements
			delete device[element]
		@firebase_ref.set device
		
		
		
module.exports = Device