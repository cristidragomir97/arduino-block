# Arduino Block 
This block allows you to compile, flash and update firmware using `arduino-cli` and `avrdude`. 
For now this is only compatible with 8-bit arduinos that use USB/UART. 

Upon runtime, the block pulls the repository found at `REPO`, compiles the skecth for the board you have set with `ARDUINO_FQBN`, and flashes it to `SERIAL_PORT` using `avrdude`

This block assumes your board is connected via a USB-to-UART bridge like `FT232H` or `CH340`. If you wish to use the RaspberryPi/Jetson native UART, you need to connect the boards reset pin to a pin on the RPi GPIO header and set the `RESET_PIN` variable. 

Additionally, for easy debugging, if `MONITOR_BAUD` is set, arduino-block will open a serial monitor once flashing is done. 

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
