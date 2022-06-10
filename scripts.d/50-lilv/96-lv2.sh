#!/bin/bash

LV2_REPO="https://github.com/lv2/lv2.git"
LV2_COMMIT="d97a1a4daff228bdd62c68859959d13077e47026"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LV2_REPO" "$LV2_COMMIT" lv2
    cd lv2
    git submodule update --init --recursive --depth 1

    local mywaf=(
        --prefix="$FFBUILD_PREFIX"
        --no-plugins
        --no-coverage
    )

    CC="${FFBUILD_CROSS_PREFIX}gcc" CXX="${FFBUILD_CROSS_PREFIX}g++" ./waf configure "${mywaf[@]}"
    ./waf -j4
    ./waf install
}
