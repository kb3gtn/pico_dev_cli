#!/bin/bash
# This script pull all the sources needed to build and setup the RP 2040/2350 PICO development environment and toolchains.
# Stuff will be installed in the directory you are running this script.

basedir="$PWD"
echo "Using basedir = ${basedir}"

# Include Dependency packages
echo "** Apt install dependencies **"
if [  -n "$(uname -a | grep Ubuntu)" ]; then
    sudo apt install automake autoconf build-essential texinfo libtool libhidapi-dev libusb-1.0-0-dev
else
    echo "  Skipped, not supported distro. Will have to do this manually"
    #arch distros: might need libhid libusb
fi 

# make tools directory
mkdir -p ${basedir}/tools

#tell pkg_config we have a special directory to consider for builds here..
#need for openocd build..
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${basedir}/tools/lib/pkgconfig"

# Pull pico_sdk
echo "** Pulling RP Pico SDK **"
git clone https://github.com/raspberrypi/pico-sdk.git pico-sdk
cd pico-sdk
git submodule update --init
cd ..

mkdir builds
cd builds

echo "** build PICOTools **"
git clone https://github.com/raspberrypi/picotool.git picotool_build
cd picotool_build
mkdir build
cd build
cmake ../
make -j8
cp picotool ../../../pico_tools/bin

# Build JimTCL for the system
echo "** Building JimTCL for OpenOCD **"
git clone https://github.com/msteveb/jimtcl.git jimtcl_build
cd jimtcl_build
./configure --prefix=${basedir}/tools
make -j8
make install
cd ..

# Build OpenOCD
echo "** Pull and build OpenOCD **"
git clone git://git.code.sf.net/p/openocd/code openocd_build
cd openocd_build
./bootstrap
./configure --enable-cmsis-dap --prefix=${basedir}/tools --disable-werror
make -j8
make install
cd ..

# leave builds dir
cd ..

# Create enviroment variables script
echo "** creating env_setup.sh -- source this to set environment variables.."
cat << EOF > env_setup.sh
#!/bin/bash
# source env_setup.sh 
export PICO_BASE=${basedir}
export PICO_SDK_PATH=${PICO_BASE}/pico_sdk
export PATH=$PATH:${PICO_BASE}/pico_tools/bin
export PICOTOOL_FETCH_FROM_GIT_PATH=${PICO_BASE}/builds/picotool_build
EOF

# Install cross-compiler 
echo "** Install arm cross compiler **"
echo " Need to do manual install if not already installed before building stuff.. "
echo " Arch Distros:"
echo "   arm-none-eabi-binutls, arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib "
echo ""
echo " Ubuntu/Debian Distros:"
echo "   binutils-arm-none-eabi gcc-arm-none-eabi newlib-arm-none-eabi gdb-multiarch"
echo ""

echo "** UDEV Rules **"
echo " install 99-picotool.rules /etc/udev/rules.d then reboot"
echo "!! Script Complete.. !!"
