FROM python:3.9-slim-bullseye AS builder

ENV PATH="/arduino:${PATH}"

RUN apt-get update && apt-get install -y curl 
RUN mkdir -p /arduino && curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/arduino sh
RUN arduino-cli core update-index
RUN arduino-cli core install arduino:avr

FROM python:3.9-slim-bullseye AS runtime

ENV PATH="/arduino:${PATH}"

RUN apt-get update && apt-get install -y avrdude python3-dev strace dbus git 

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


RUN arduino-cli core install arduino:avr

RUN pip3 install pyserial

WORKDIR /usr/src/repo 

RUN git clone ${REPO}  \
    && cd {REPO_NAME} \
    && cd {SKETCH_FOLDER} \
    && arduino-cli compile --fqbn ${ARDUINO_FQBN} firmware.ino --export-binaries

CMD avrdude -v -p ${AVRDUDE_CPU} -c arduino -P ${SERIAL_PORT} -b 57600 -D -U flash:w:/firmware.ino.with_bootloader.hex \
    && python3 -m serial.tools.miniterm ${SERIAL_PORT} ${MONITOR_BAUD} 


