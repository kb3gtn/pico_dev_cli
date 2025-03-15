# pico_dev_cli

Build and setup toolchain and sdk to work via cmake on the linux command line.
All component will be placed at the directory level you run the script from.

This script will pull pico-sdk from git and build picotool
This tool will also pull jimtcl and openocd and build the jtag solution as well.

help full scripts and tool binaries are located in pico_tools/bin

This script is a prototype to automate the setup process. Still a work in progress..

comes with a simple blinky example you can try and build once the install is complete to test
if the build environment is working correctly.
