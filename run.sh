#! /bin/sh
export DBUS_SYSTEM_BUS_ADDRESS="unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.MaskUnitFiles \
  array:string:\"serial-getty@serial0.service\" \
  boolean:true \
  boolean:true"

export DBUS_SYSTEM_BUS_ADDRESS="unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:\"serial-getty@serial0.service\" \
  string:replace" 

rm -rf /usr/firmware && git clone ${REPO} /usr/firmware
cd /usr/firmware${SKETCH_FOLDER}

arduino-cli compile --fqbn ${ARDUINO_FQBN} firmware.ino --export-binaries

cd /usr/firmware/firmware/build/arduino.*/

avrdude -v -p ${AVRDUDE_CPU} -c arduino -P ${SERIAL_PORT} -b 57600 -D -U flash:w:/firmware.ino.with_bootloader.hex \
python3 -m serial.tools.miniterm ${SERIAL_PORT} ${MONITOR_BAUD} 

