#!/bin/bash

set -ex
mkdir -pv _build
pushd _build

# set PYTHON_LIBS for macOS (don't link against libpython)
if [[ "$(uname)" == "Darwin" ]]; then
  export PYTHON_LIBS="-Wl,-undefined,dynamic_lookup"
fi

# only link GSL libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
${SRC_DIR}/configure \
  --enable-gtk-doc-html=no \
  --enable-gtk-doc-pdf=no \
  --enable-introspection=yes \
  --prefix=${PREFIX} \
  --with-doxygen=no \
  --with-zlib=${PREFIX} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 install

# some tests fail
#make -j ${CPU_COUNT} V=1 VERBOSE=1 check
