#!/bin/bash

GMP_SRC="https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    wget -O gmp.tar.xz "$GMP_SRC" --tries=3 || curl -L -o gmp.tar.xz "$GMP_SRC" --retry 3
    tar xaf gmp.tar.xz
    rm gmp.tar.xz
    cd gmp*

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
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
    echo --enable-gmp
}

ffbuild_unconfigure() {
    echo --disable-gmp
}
