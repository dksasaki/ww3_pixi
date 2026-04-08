#!/bin/bash

export NetCDF_ROOT=$pixi_root"/bin"
export ROOT_PIXI=$PWD

# Clone and build WW3
git clone https://github.com/NOAA-EMC/WW3.git
cd WW3
mkdir build && cd build
cmake .. -DSWITCH=${ROOT_PIXI}/WW3/model/bin/switch_NCEP_st2 -DCMAKE_INSTALL_PREFIX=install
make
make install

cd ..
sh model/bin/ww3_from_ftp.sh

cd regtests

./bin/run_cmake_test ../model ww3_tp1.1
