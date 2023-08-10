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
    git clone https://github.com/CESNET/libyang-cpp.git "$root_path/repos/libyang-cpp"
    git clone https://github.com/sysrepo/sysrepo.git "$root_path/repos/sysrepo"
    git clone https://github.com/sysrepo/sysrepo-cpp.git "$root_path/repos/sysrepo-cpp"
}

build_repo () {
    # build wether libyang or sysrepo, arguments needed are root/CMake prefix path
    local prefix_path="$1"
    mkdir build
    cmake -S . -B build/ -DCMAKE_PREFIX_PATH=$prefix_path -DCMAKE_INSTALL_PREFIX:PATH=$prefix_path -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DSHM_DIR="$prefix_path/dev/shm" -DREPO_PATH="$prefix_path/etc/sysrepo"
    cmake --build build/ -j
    cmake --build build/ --target install
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: setup.sh <path-to-dev-env-root>"
else
    current_dir=$(pwd)
    fs_root=$1

    echo "Creating directories..."
    create_root_structure "$fs_root"

    echo "Cloning repositories..."
    download_repos "$fs_root"
    
    echo "Setting up, building and installing libyang/sysrepo..."

    # libyang
    cd "$fs_root/repos/libyang"
    git checkout devel
    build_repo "$fs_root"

    # libyang-cpp
    cd "$fs_root/repos/libyang-cpp"
    build_repo "$fs_root"

    # sysrepo
    cd "$fs_root/repos/sysrepo"
    git checkout devel
    build_repo "$fs_root"

    # sysrepo-cpp
    cd "$fs_root/repos/sysrepo-cpp"
    build_repo "$fs_root"

    # return back
    cd $current_dir
fi 
