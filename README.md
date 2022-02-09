# Arduino Block 

Right now, this is only compatible with 8-bit arduinos that use USB/UART 


## Variables 

| Variable | Description | Example | 
| ----------- | ----------- |----------- |
| `AVRDUDE_CPU` | Name of the microcontroller your board is based on | `atmega328p` |
| `MONITOR_BAUD` | Baud rate for miniterm (after flashing, the arduino service opens a serial terminal for monitoring) | `9600` |
| `SERIAL_PORT` | Serial port your board is connected to. | `/dev/ttyUSB0` |
| `REPO` | Repository containing a valid arduino-cli sketch |  | 
| `SKETCH_FOLDER` | Subfolder of the sketch (if required) | | 
| `ARDUINO_FQBN` | Board identification ID that follows this naming convention: `VENDOR:ARCHITECTURE:BOARD_ID[:MENU_ID=OPTION_ID[,MENU2_ID=OPTION_ID ...]]` | `arduino:avr:pro:cpu=8MHzatmega328` |  arduino:avr:pro:cpu=8MHzatmega328 | 
| `RESET_PIN` | RPi GPIO Pin used for arduino reset (if connected to native UART) | 18| 