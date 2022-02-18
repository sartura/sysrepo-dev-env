#!/usr/bin/bash

if [ $# -ne 1 ]
  then
    echo "No arguments supplied"
    echo "Usage: export-libyang2.sh <dev-env-root>"
else
    root=$1
    # add libyang2 paths
    export PATH=$root/libyang2/bin:$PATH
    export LD_LIBRARY_PATH=$root/libyang2/lib:$LD_LIBRARY_PATH
    export PKG_CONFIG_PATH=$root/libyang2/lib/pkgconfig:$PKG_CONFIG_PATH
fi