#!/usr/bin/bash

create_root_structure () {
    # first create root dir given
    mkdir $1

    # create root structure
    local path="$1"
    mkdir $path/{bin,lib,include,dev,etc,share,repos,plugins}
}

download_repos () {
    local root_path="$1"
    git clone https://github.com/CESNET/libyang.git "$root_path/repos/libyang"
    git clone https://github.com/sysrepo/sysrepo.git "$root_path/repos/sysrepo"
}

setup_sysrepo_config () {
    local shm_path="$1/$2/dev/shm"
    local ly_version="$2"
    local config_path="$3"
    # create shm dir
    mkdir $shm_path
    sed -i "s|#define SR_SHM_DIR \"/dev/shm\"|#define SR_SHM_DIR \"$shm_path\"|" $config_path
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

    echo "Creating directories..."
    create_root_structure "$1/libyang1"
    create_root_structure "$1/libyang2"
    mkdir $1/repos

    # download once instead of each time for specific LY version
    echo "Cloning repositories..."
    download_repos "$1"
    
    # copy repos in their respected sub-dirs

    # libyang
    cp -r $1/repos/libyang $1/libyang1/repos/libyang
    cp -r $1/repos/libyang $1/libyang2/repos/libyang

    # sysrepo
    cp -r $1/repos/sysrepo $1/libyang1/repos/sysrepo
    cp -r $1/repos/sysrepo $1/libyang2/repos/sysrepo

    # setup libyang1 repo branches

    echo "Setting up libyang1 version..."

    # libyang
    cd "$1/libyang1/repos/libyang"
    git checkout libyang1
    build_repo "$1/libyang1"

    # sysrepo
    cd "$1/libyang1/repos/sysrepo"
    git checkout libyang1
    setup_sysrepo_config "$1" "libyang1" "src/common.h.in"
    build_repo "$1/libyang1"

    # setup libyang2 repo branches

    echo "Setting up libyang2 version..."

    # libyang
    cd "$1/libyang2/repos/libyang"
    git checkout devel
    build_repo "$1/libyang2"

    # sysrepo
    cd "$1/libyang2/repos/sysrepo"
    git checkout devel
    setup_sysrepo_config "$1" "libyang2" "src/config.h.in"
    build_repo "$1/libyang2"

    # return back
    cd $current_dir
fi 