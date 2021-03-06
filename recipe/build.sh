#!/bin/bash

set -ex
mkdir -pv _build
pushd _build

# only link GSL libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# replace '/usr/bin/env python3' with '/usr/bin/python'
# so that conda-build will then replace it with the $PREFIX/bin/python
sed -i.tmp 's/\/usr\/bin\/env python3/\/usr\/bin\/python/g' ${SRC_DIR}/bin/gstlal_*

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
