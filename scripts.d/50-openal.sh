#!/bin/bash

SCRIPT_REPO="https://github.com/kcat/openal-soft.git"
SCRIPT_COMMIT="188a637c70019108d980f72b8521673b5648d19e"

ffbuild_enabled() {
    [[ $ADDINS_STR == *4.4* ]] && return -1
    [[ $ADDINS_STR == *5.0* ]] && return -1
    [[ $ADDINS_STR == *5.1* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    mkdir cm_build && cd cm_build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DLIBTYPE=STATIC -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF  ..
    make -j4
    make install

    echo "Libs.private: -lstdc++" >> "$FFBUILD_PREFIX"/lib/pkgconfig/openal.pc

    if [[ $TARGET == win* ]]; then
        echo "Libs.private: -lole32" >> "$FFBUILD_PREFIX"/lib/pkgconfig/openal.pc
    fi
}

ffbuild_configure() {
    echo --enable-openal
}

ffbuild_unconfigure() {
    echo --disable-openal
}
