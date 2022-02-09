FROM python:3.9-slim-bullseye AS builder

ENV PATH="/arduino:${PATH}"


RUN apt-get update && apt-get install -y curl 
RUN mkdir -p /arduino && curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/arduino sh
RUN arduino-cli core update-index
RUN arduino-cli core install arduino:avr arduino:megaavr arduino:samd


FROM python:3.9-slim-bullseye AS runtime

ENV PATH="/arduino:${PATH}"

RUN apt-get update && apt-get install -y avrdude python3-dev python3-rpi.gpio strace dbus

COPY --from=builder /arduino /arduino

ENV DBUS_SYSTEM_BUS_ADDRESS="unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.MaskUnitFiles \
  array:string:\"serial-getty@serial0.service\" \
  boolean:true \
  boolean:true"

ENV DBUS_SYSTEM_BUS_ADDRESS="unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:\"serial-getty@serial0.service\" \
  string:replace" 

WORKDIR /usr/sketch
COPY sketch.ino /usr/sketch/sketch.ino
COPY autoreset  autoreset
COPY run_avrdude.sh run_avrdude.sh

RUN pip3 install pyserial

RUN chmod +x autoreset
RUN chmod +x run_avrdude.sh

RUN arduino-cli compile --fqbn ${ARDUINO_FQBN} sketch.ino --export-binaries

CMD ./run_avrdude.sh -v -p ${AVRDUDE_CPU} -c arduino -P ${SERIAL_PORT} -b 57600 -D -U flash:w:/flashme.hex \
    && python3 -m serial.tools.miniterm ${SERIAL_PORT} ${MONITOR_BAUD}

