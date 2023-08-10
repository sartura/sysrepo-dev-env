#!/usr/bin/bash

if [ $# -ne 1 ]
  then
    echo "No arguments supplied"
    echo "Usage: export.sh <dev-env-root>"
else
    root=$1
    # add libyang2 paths
    export SRPD_PLUGINS_PATH=$root/plugins
    export PATH=$root/bin:$PATH
    export LD_LIBRARY_PATH=$root/lib:$LD_LIBRARY_PATH
    export PKG_CONFIG_PATH=$root/lib/pkgconfig:$PKG_CONFIG_PATH
fi
