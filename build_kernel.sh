export ARCH=arm64
export SUBARCH=arm64
export ak=$HOME/AnyKernel3
export PATH="$HOME/proton-clang/bin:$PATH"
export KBUILD_COMPILER_STRING="$($HOME/proton-clang/bin/clang --version | head -n 1 | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')";

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
make clean -j$(nproc --all) && make mrproper -j$(nproc --all)
make weeb_defconfig -j$(nproc --all)
make -j$(nproc --all) Image.gz-dtb \
CC="clang" \
CLANG_TRIPLE="aarch64-linux-gnu-" \
CROSS_COMPILE="aarch64-linux-gnu-" \
CROSS_COMPILE_ARM32="arm-linux-gnueabi-" \
LD=ld.lld \
AR=llvm-ar \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip

cp out/arch/arm64/boot/Image.gz-dtb $ak/Image.gz-dtb
find out/arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > $ak/dtb
cd $ak
zip -FSr9 $ak/kernel.zip ./*
