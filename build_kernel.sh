#!/bin/bash

###############################################################################
# credits to UpInTheAir                          			      #
#                                                         		      #
###############################################################################

# Time of build startup
res1=$(date +%s.%N)

echo "${bldcya}***** Setting up Environment *****${txtrst}";

. ./env_setup.sh ${1} || exit 1;

if [ ! -f $KERNELDIR/.config ]; then
	echo "${bldcya}***** Writing Config *****${txtrst}";
	cp $KERNELDIR/arch/arm64/configs/$KERNEL_CONFIG .config;
	make ARCH=arm64 $KERNEL_CONFIG;
fi;

. $KERNELDIR/.config

# remove previous Image files
if [ -e $KERNELDIR/arch/arm64/boot/Image ]; then
	rm $KERNELDIR/arch/arm64/boot/Image;
fi;
if [ -e $KERNELDIR/arch/arm64/boot/dt.img ]; then
	rm $KERNELDIR/arch/arm64/boot/dt.img;
fi;

# Cleanup old dtb files
rm -rf $KERNELDIR/arch/arm64/boot/dts/*.dtb;

echo "Done"

# make Image
echo "${bldcya}***** Compiling kernel *****${txtrst}"
if [ $USER != "root" ]; then
	make CONFIG_DEBUG_SECTION_MISMATCH=y -j5 Image ARCH=arm64
else
	make -j5 Image ARCH=arm64
fi;

if [ -e $KERNELDIR/arch/arm64/boot/Image ]; then
	echo "${bldcya}***** Final Touch for Kernel *****${txtrst}"
	stat $KERNELDIR/arch/arm64/boot/Image || exit 1;
	
	echo "--- Creating dt.img ---"
	./utilities/dtbtool -o dt.img -s 2048 -p ./scripts/dtc/dtc ./arch/arm64/boot/dts/
	mv ./dt.img ./arch/arm64/boot/

echo ""
echo "${bldcya}***** Compiled Image and dt.img found in directory /arch/arm64/boot/ *****${txtrst}";
echo ""

	exit 0;
else
	echo "${bldred}Kernel STUCK in BUILD!${txtrst}"
fi;
