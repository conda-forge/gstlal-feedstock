#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./gnuscripts

set -ex
mkdir -pv _build
pushd _build

# ensure that pkg-config is picked up from the build environment,
# not the host environment
export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"

# only link GSL libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# replace '/usr/bin/env python3' with '/usr/bin/python'
# so that conda-build will then replace it with the $PREFIX/bin/python
sed -i.tmp 's/\/usr\/bin\/env python3/\/usr\/bin\/python/g' ${SRC_DIR}/bin/gstlal_*

# disable introspection when cross-compiling,
# (cross-copmiled gstreamer doesn't support it, see
# https://github.com/conda-forge/gstreamer-feedstock/blob/c09dab7f241742d5911603d964a362036bb963f4/recipe/install_gstreamer.sh#L8-L15
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    ENABLE_INTROSPECTION="no"
else
    ENABLE_INTROSPECTION="yes"
fi

# configure
${SRC_DIR}/configure \
  --enable-gtk-doc-html=no \
  --enable-gtk-doc-pdf=no \
  --enable-introspection=${ENABLE_INTROSPECTION} \
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
