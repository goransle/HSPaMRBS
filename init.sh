nodemcu-tool upload init.lua -p /dev/tty.usbserial-0001 --connection-delay 400
nodemcu-tool upload restart.lua -p /dev/tty.usbserial-0001 --connection-delay 400
nodemcu-tool upload secrets.lua -p /dev/tty.usbserial-0001 --connection-delay 400
nodemcu-tool upload app.lua -p /dev/tty.usbserial-0001 --connection-delay 400
nodemcu-tool terminal --run restart.lua -p /dev/tty.usbserial-0001 --connection-delay 400