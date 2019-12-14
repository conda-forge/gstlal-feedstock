#!/bin/bash

# conda-forge/conda-forge.github.io#621
find ${PREFIX} -name "*.la" -delete

# shortcut version of lscsoft/gstlal@027249b601a729eb3a096e7834ee7f5a2c527f43
export LIBS="-lz"

# only link GSL libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
./configure \
  --prefix=${PREFIX} \
  --without-doxygen \
  --with-html-dir=$(pwd)/tmphtml

# build
make -j ${CPU_COUNT}

# install
make -j ${CPU_COUNT} install
