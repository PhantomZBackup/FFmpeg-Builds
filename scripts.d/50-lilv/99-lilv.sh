#!/bin/bash

SCRIPT_REPO="https://github.com/lv2/lilv.git"
SCRIPT_COMMIT="aaba53520913cfdb27caa09bd2e682739294fade"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" lilv
    cd lilv

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dtools=disabled
        -Dtests=disabled
        -Dbindings_py=disabled
    )

    CC="${FFBUILD_CROSS_PREFIX}gcc" CXX="${FFBUILD_CROSS_PREFIX}g++" ./waf configure "${mywaf[@]}"
    ./waf -j4
    ./waf install

    meson "${myconf[@]}" ..
    ninja -j4
    ninja install
}

ffbuild_configure() {
    echo --enable-lv2
}

ffbuild_unconfigure() {
    echo --disable-lv2
}
