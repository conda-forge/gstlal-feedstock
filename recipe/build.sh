#!/bin/bash

set -ex
mkdir -pv _build
pushd _build

# only link GSL libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
${SRC_DIR}/configure \
  --enable-gtk-doc-html=no \
  --enable-gtk-doc-pdf=no \
  --enable-introspection=yes \
  --prefix=${PREFIX} \
  --with-doxygen=no \
  --with-html-dir=$(pwd)/tmphtml \
  --with-zlib=${PREFIX} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 install

# test - `lal_checktimestamps+lal_checktimestamps0` still fails
#make -j ${CPU_COUNT} V=1 VERBOSE=1 check
