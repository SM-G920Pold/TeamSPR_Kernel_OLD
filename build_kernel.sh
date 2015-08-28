#!/bin/bash

export ARCH=arm64

# Clean up
./build_clean.sh
make mrproper
ccache -c

# Set toolchain
export CROSS_COMPILE=/home/buildserver/android/toolchains/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-

# Make .config
make ARCH=arm64 exynos7420-zerofltespr_defconfig

# Compile Image
make -j5 ARCH=arm64
