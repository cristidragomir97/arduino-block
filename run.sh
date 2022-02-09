#! /bin/sh

git clone ${REPO} /tmp/firmware
cd /tmp/${SKETCH_FOLDER}

arduino-cli compile --fqbn ${ARDUINO_FQBN} firmware.ino --export-binaries

./run_avrdude.sh -v -p ${AVRDUDE_CPU} -c arduino -P ${SERIAL_PORT} -b 57600 -D -U flash:w:/flashme.hex \
python3 -m serial.tools.miniterm ${SERIAL_PORT} ${MONITOR_BAUD} 