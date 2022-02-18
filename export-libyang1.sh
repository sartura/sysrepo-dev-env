#!/usr/bin/bash

if [ $# -ne 1 ]
  then
    echo "No arguments supplied"
    echo "Usage: export-libyang1.sh <dev-env-root>"
else
    root=$1
    # add libyang1 paths
    export PATH=$root/libyang1/bin:$PATH
    export LD_LIBRARY_PATH=$root/libyang1/lib:$LD_LIBRARY_PATH
    export PKG_CONFIG_PATH=$root/libyang1/lib/pkgconfig:$PKG_CONFIG_PATH
fi