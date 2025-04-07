#!/bin/bash

set -e

ARCH=`uname -m`

if [ X"${ARCH}" == X"x86_64" ] ; then
	GCC=`realpath ../gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu`
	CROSS_COMPILE_ARM64=${GCC}/bin/aarch64-none-linux-gnu-
else
	echo "${ARCH} is not supported now!"
	exit 1
fi

# Clean the old files.
rm -rf spl/u-boot-spl* #tpl/

# Start building (U-Boot, SPL, etc.)
make CROSS_COMPILE=${CROSS_COMPILE_ARM64} rk3588_defconfig
make CROSS_COMPILE=${CROSS_COMPILE_ARM64} -j`nproc`

# Call the official build.
./make.sh rk3588

ls -alh fit/uboot.itb

mkdir -p ../rockdev/
cp -a fit/uboot.itb ../rockdev/uboot.img
ls -alh ../rockdev/uboot.img
md5sum ../rockdev/uboot.img
echo "All done!"

