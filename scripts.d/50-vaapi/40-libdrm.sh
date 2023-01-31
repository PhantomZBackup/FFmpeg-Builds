#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/mesa/drm.git"
SCRIPT_COMMIT="0e2c7d05712d65903a9b77fb9f960ddff43bac64"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" libdrm
    cd libdrm

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        -Ddefault_library=shared
        -Dudev=false
        -Dcairo-tests=disabled
        -Dvalgrind=disabled
        -Dexynos=disabled
        -Dfreedreno=disabled
        -Domap=disabled
        -Detnaviv=disabled
        -Dintel=enabled
        -Dnouveau=enabled
        -Dradeon=enabled
        -Damdgpu=enabled
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$RAW_CFLAGS"
    export LDFLAFS="$RAW_LDFLAGS"

    meson "${myconf[@]}" ..
    ninja -j4
    ninja install

    gen-implib "$FFBUILD_PREFIX"/lib/{libdrm.so.2,libdrm.a}
    rm "$FFBUILD_PREFIX"/lib/libdrm*.so*

    echo "Libs: -ldl" >> "$FFBUILD_PREFIX"/lib/pkgconfig/libdrm.pc
}

ffbuild_configure() {
    echo --enable-libdrm
}

ffbuild_unconfigure() {
    echo --disable-libdrm
}
