## Work done for the board STM32F401CD

### 1) Creating object and binary files

> arm-none-eabi-as -o blink.o blinks.s  <br/>

> arm-none-eabi-ld -Ttext=0x8000000 -o blink.elf blink.o  <br/>

> arm-none-eabi-objcopy -Obinary blink.elf blink.bin  <br/>

> .\openocd.exe -f stm32f4x.cfg  <br/>

### 2) Opening a second terminal window

> telnet.exe localhost 4444  <br/>

> program blink.bin 0x8000000  <br/>

### 3) Reconnect the board. Diode blinking!