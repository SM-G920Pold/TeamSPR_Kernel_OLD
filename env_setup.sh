#!/bin/bash

# Colorize and add text parameters
export red=$(tput setaf 1)             #  red
export grn=$(tput setaf 2)             #  green
export blu=$(tput setaf 4)             #  blue
export cya=$(tput setaf 6)             #  cyan
export txtbld=$(tput bold)             #  Bold
export bldred=${txtbld}$(tput setaf 1) #  red
export bldgrn=${txtbld}$(tput setaf 2) #  green
export bldblu=${txtbld}$(tput setaf 4) #  blue
export bldcya=${txtbld}$(tput setaf 6) #  cyan
export txtrst=$(tput sgr0)             #  Reset

echo "${bldcya}***** Clean up Environment before compile *****${txtrst}";

# Make clean source
read -t 5 -p "Make clean source, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
./build_clean.sh;
make distclean;
make mrproper;
fi;

# clean ccache
read -t 5 -p "Clean ccache, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
ccache -c;
fi;

TARGET=$1
if [ "$TARGET" != "" ]; then
        echo "Starting your build for $TARGET"
else
        echo ""
        echo "You need to define your device target!"
        echo "example: build_kernel.sh G920P"
        exit 1
fi

# location
	export KERNELDIR=`readlink -f .`;

# check if ccache installed, if not install
if [ ! -e /usr/bin/ccache ]; then
	echo "You must install 'ccache' to continue.";
	sudo apt-get install ccache
fi

# check if xmllint installed, if not install
if [ ! -e /usr/bin/xmllint ]; then
	echo "You must install 'xmllint' to continue.";
	sudo apt-get install libxml2-utils
fi

# kernel
export ARCH=arm64;
export SUB_ARCH=arm64;
if [ "$TARGET" = "G920P" ] ; then
export KERNEL_CONFIG="exynos7420-zerofltespr_defconfig";
fi

# build script
export USER=`whoami`;
export TMPFILE=`mktemp -t`;

# system compiler
export CROSS_COMPILE=/home/buildserver/android/toolchains/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-

# CPU Core
export NUMBEROFCPUS=`grep 'processor' /proc/cpuinfo | wc -l`;