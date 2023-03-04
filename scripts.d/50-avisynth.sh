#!/bin/bash

SCRIPT_REPO="https://github.com/AviSynth/AviSynthPlus.git"
SCRIPT_COMMIT="7325e56fb10c5d3c01278d54d55ea291214e3284"

ffbuild_enabled() {
    [[ $VARIANT == lgpl* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" avisynth
    cd avisynth

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DHEADERS_ONLY=ON ..
    make -j4
    make VersionGen install
}

ffbuild_configure() {
    echo --enable-avisynth
}

ffbuild_unconfigure() {
    echo --disable-avisynth
}
