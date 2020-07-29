#!/bin/bash

export ARCH=arm64 && export SUBARCH=arm
export CROSS_COMPILE=$HOME/arm64-gcc/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=$HOME/arm32-gcc/bin/arm-eabi-
export ak3=$HOME/AnyKernel3

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
make clean -j$(nproc --all) && make mrproper -j$(nproc --all)
make kaz205_defconfig -j$(nproc --all)
make -j$(nproc --all)

cp -f out/arch/arm64/boot/Image.gz $ak3/Image.gz
find out/arch/arm64/boot/dts -name *.dtb -exec cp -f "{}" $ak3/dtb \;
cd $ak3
zip -FSr $ak3/kernel.zip ./*
