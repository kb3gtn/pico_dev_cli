# PICO CLI Development tooling setup script

This is a script to pull and build all the needed stuff to development for the RP2040 and RP2350 CPU's using a CLI / CMAKE environment using openocd for debugging.


## Run Script to create environment.
use git to clone this repository to a directory of your choosing.   
run the './build_pico_devtools.sh' script   

## Using the environment
to use the environment you will need to source the "env_setup.sh" file to load environment variables into your shell.    

There is a test project "blink" located in "/projects" directory.   
to build this test project do the following:   
```
cd project/blink
mkdir build
cd build
cmake ../
make
```
This should make a blink.elf file.   
You can load this file via openocd and picodebug using pico_load script as follows:   
```
pico_load blink.elf
```
For RP2350 targets, use pico2_load instead.  
For debugging use can use the pico_debug_server / pico2_debug_server to create a GDB remote target.


## manual stuff

### udev rules
copy 99-picotools.rules to /etc/udev/rules.d  

### Package Dependencies for builds

On Ubuntu/Debian distros:   
  sudo apt install binutils-arm-none-eabi gcc-arm-none-eabi newlib-arm-none-eabi gdb-multiarch cmake build-essential git libhidapi-dev libusb-1.0-0-dev
  
For Arch base distros:    
  sudo pacman -S arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib cmake git hidapi libusb

