#!/usr/bin/bash

create_root_structure () {
    # first create root dir given
    mkdir $1

    # create root structure
    local path="$1"
    mkdir "$path/bin" "$path/lib" "$path/include" "$path/etc" "$path/share" "$path/repos"
}

download_repos () {
    local root_path="$1"
    git clone https://github.com/sysrepo/sysrepo.git "$root_path/repos/sysrepo"
    git clone https://github.com/CESNET/libyang.git "$root_path/repos/libyang"
}

build_repo () {
    # build wether libyang or sysrepo, arguments needed are root/CMake prefix path
    local prefix_path="$1"
    mkdir build
    cd build
    cmake -DCMAKE_PREFIX_PATH=$prefix_path -DCMAKE_INSTALL_PREFIX:PATH=$prefix_path ..
    make -j
    make install
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: setup.sh <path-to-dev-env-root>"
else
    current_dir=$(pwd)

    create_root_structure "$1/libyang1"
    create_root_structure "$1/libyang2"

    download_repos "$1/libyang1"
    download_repos "$1/libyang2"

    # setup libyang1 repo branches

    # libyang
    cd "$1/libyang1/repos/libyang"
    git checkout libyang1
    build_repo "$1/libyang1"

    # sysrepo
    cd "$1/libyang1/repos/sysrepo"
    git checkout libyang1
    build_repo "$1/libyang1"

    # setup libyang2 repo branches

    # libyang
    cd "$1/libyang2/repos/libyang"
    git checkout devel
    build_repo "$1/libyang2"

    # sysrepo
    cd "$1/libyang2/repos/sysrepo"
    git checkout devel
    build_repo "$1/libyang2"

    # return back
    cd $current_dir
fi 