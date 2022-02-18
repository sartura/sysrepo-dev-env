# sysrepo-dev-env
Set of scripts to setup an environment for sysrepo plugin development. Updated version of [setup-dev-sysrepo](https://github.com/sartura/setup-dev-sysrepo), including only sysrepo and libyang as libraries/dependencies and also supporting development for libyang1 and libyang2 branches of repositories.

## Installing
Run `install-dependencies.sh` to install all libraries needed to build libyang and sysrepo.

```
sudo ./install-dependencies.sh
```

After all dependencies have been installed, run `setup.sh`. The script creates 2 directories, `libyang1` and `libyang2`, in the directory providev via an argument:

```
./setup.sh
Usage: setup.sh <path-to-dev-env-root>
```

For example:
```
./setup.sh ~/sysrepo-dev/
```
When the setup script finishes, you can use export scripts to export needed environment variables like `$PATH` or `$LD_LIBRARY_PATH`, either for libyang1 or libyang2, depending on which versions of the plugin you are using.

Example usage of an export script:
```
source ./export-libyang2.sh ~/sysrepo-dev
```

When building plugins, make sure to use `CMAKE_PREFIX_PATH` and point the variable to the root of either libyang1 or libyang2 directory created using the `setup.sh` script. For example:

```
cmake -DCMAKE_PREFIX_PATH=~/sysrepo-dev/libyang2 -DCMAKE_INSTALL_PREFIX:PATH=~/sysrepo-dev/libyang2 ..
```