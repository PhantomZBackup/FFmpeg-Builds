#!/bin/bash

SCRIPT_REPO1="https://repo.or.cz/libiconv.git"
SCRIPT_REPO2="https://repo.or.cz/gnulib.git"
SCRIPT_BRANCH="master"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "git-mini-clone \"$SCRIPT_REPO1\" \"$SCRIPT_BRANCH\" iconv"
    echo "cd iconv && git-mini-clone \"$SCRIPT_REPO2\" \"$SCRIPT_BRANCH\" gnulib"
}

ffbuild_dockerbuild() {
    (unset CC CFLAGS GMAKE && ./autogen.sh)

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-extra-encodings
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
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-iconv
}

ffbuild_unconfigure() {
    echo --disable-iconv
}
