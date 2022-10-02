#!/bin/bash

SCRIPT_REPO="https://chromium.googlesource.com/webm/libwebp"
SCRIPT_COMMIT="e68765af4256287b55334c362fcf0f177f4bbb7c"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" webp
    cd webp

    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --enable-libwebpmux
        --disable-libwebpextras
        --disable-libwebpdemux
        --disable-sdl
        --disable-gl
        --disable-png
        --disable-jpeg
        --disable-tiff
        --disable-gif
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j4
    make install
}

ffbuild_configure() {
    echo --enable-libwebp
}

ffbuild_unconfigure() {
    echo --disable-libwebp
}
