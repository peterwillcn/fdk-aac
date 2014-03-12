#!/bin/bash

TOOLCHAIN=/tmp/Shou
$ANDROID_NDK/build/tools/make-standalone-toolchain.sh --toolchain=arm-linux-androideabi-4.8 \
  --system=linux-x86_64 --platform=android-19 --install-dir=$TOOLCHAIN

export PATH=$TOOLCHAIN/bin:$PATH
export CC="ccache arm-linux-androideabi-gcc"
export LD=arm-linux-androideabi-ld
export STRIP=arm-linux-androideabi-strip

export CFLAGS="-std=c99 -O3 -Wall -mthumb -pipe -fpic -fasm \
  -march=armv7-a -mfpu=neon -mfloat-abi=hard -mvectorize-with-neon-quad \
  -finline-limit=300 -ffast-math -fmodulo-sched -fmodulo-sched-allow-regmoves \
  -mhard-float -D_NDK_MATH_NO_SOFTFP=1 -fdiagnostics-color=always \
  -Wno-psabi -Wa,--noexecstack \
  -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ \
  -DANDROID -DNDEBUG"

export LDFLAGS="-lm_hard -lz -Wl,--no-undefined -Wl,-z,noexecstack -Wl,--fix-cortex-a8 -Wl,--no-warn-mismatch"

autoreconf -fiv
./configure --host=arm-linux-androideabi --prefix="`pwd`/build/" --disable-shared
rm -r build
make -j7
make install
make distclean
