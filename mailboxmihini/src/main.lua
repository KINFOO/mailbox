--------------------------------------------------------------------------------
-- All rights reserved. This program and the accompanying materials
-- are made available under the terms of the Eclipse Public License v1.0
-- which accompanies this distribution, and is available at
-- http://www.eclipse.org/legal/epl-v10.html
--------------------------------------------------------------------------------
local airvantage = require 'airvantage'
local log        = require 'log'
local os         = require 'os'
local serial     = require 'serial'
local sched      = require 'sched'
--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------
local ASSET_ID       = "mailbox"
local LOG_ENTRY_NAME = "MAILBOX_APP"
local SERIAL_PORT    = "/dev/ttyACM0"
local SERIAL_CONF = {
	baudRate    = 9600,
	numDataBits = 8
}

local function main()
	--
	-- Initialize serial port communication
	--
	local dev, error = serial.open(SERIAL_PORT,SERIAL_CONF)
	if not dev then
		log(LOG_ENTRY_NAME, "ERROR", "Unable to communicate over %s: %s",
			SERIAL_PORT, error)
		return
	end

	--
	-- Initialize Air Vantage communication
	--
	if not airvantage.init() then
		log(LOG_ENTRY_NAME, "ERROR", "Unable to initialize AirVantage.")
		return
	end
	local asset = airvantage.newasset(ASSET_ID)
	if not asset  or asset:start() then
		log(LOG_ENTRY_NAME, "ERROR",
			"Unable to initialize and start AirVantage asset.")
		return
	end

	--
	-- Read from serial port
	--
	repeat
		local serialvalue = dev:read(1)
		log(LOG_ENTRY_NAME, "INFO", "There was a %s{%s} on `%s`.",
		type(serialvalue), tostring(serialvalue), SERIAL_PORT)

		--
		-- Format date to send
		--
		local time = os.time()
		local date = os.date('*t', time)
		local data = {
			lastdeliverydate = string.format('%d-%d-%d %d:%d:%d', date.year,
			date.month, date.day, date.hour, date.min, date.sec),
			timestamp        = time * 1000
		}
		asset:pushdata ('data', data, 'now')
	until not serialvalue
	dev:close()
	return 'ok'
end

-- Run app
sched.run(main)
sched.loop()
