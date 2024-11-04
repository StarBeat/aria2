# cd /workspaces
# wget https://musl.cc/aarch64-linux-musl-cross.tgz && tar xf aarch64-linux-musl-cross.tgz && rm aarch64-linux-musl-cross.tgz

export TOOLCHAIN=/workspaces/aarch64-linux-musl-cross/bin
export TOOLCHAIN_PREFIX=aarch64-linux-musl
export CPP=$TOOLCHAIN/$TOOLCHAIN_PREFIX-cpp 
export CC=$TOOLCHAIN/$TOOLCHAIN_PREFIX-gcc 
export CXX=$TOOLCHAIN/$TOOLCHAIN_PREFIX-g++ 
export LD=$TOOLCHAIN/$TOOLCHAIN_PREFIX-ld 
export AR=$TOOLCHAIN/$TOOLCHAIN_PREFIX-ar 
export AS=$TOOLCHAIN/$TOOLCHAIN_PREFIX-as 
export RANLIB=$TOOLCHAIN/$TOOLCHAIN_PREFIX-ranlib 
export STRIP=$TOOLCHAIN/$TOOLCHAIN_PREFIX-strip

export PREFIX=/workspaces/aria2/install
export HOST=aarch64-linux
 
# # Build zlib
# ZLIB_VERSION=1.3.1
# ZLIB_ARCHIVE=zlib-$ZLIB_VERSION.tar.gz
# ZLIB_URI=https://github.com/madler/zlib/releases/download/v1.3.1/$ZLIB_ARCHIVE

# cd /workspaces
# curl -L -O $ZLIB_URI && tar xf $ZLIB_ARCHIVE && rm $ZLIB_ARCHIVE
# cd /workspaces/zlib-$ZLIB_VERSION
# ./configure \
#       --prefix=$PREFIX \
#       --libdir=$PREFIX/lib \
#       --includedir=$PREFIX/include \
#       --static && \
#     make -j$(nproc) install

# # Build c-ares
# CARES_VERSION=1.21.0
# CARES_ARCHIVE=c-ares-$CARES_VERSION.tar.gz
# CARES_URI=https://github.com/c-ares/c-ares/releases/download/cares-1_21_0/$CARES_ARCHIVE

# cd /workspaces
# curl -L -O $CARES_URI && tar xf $CARES_ARCHIVE && rm $CARES_ARCHIVE

# cd /workspaces/c-ares-$CARES_VERSION
# ./configure \
#   --host=$HOST \
#   --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` \
#   --prefix=$PREFIX \
#   --disable-shared && \
#   make -j$(nproc) install

# # Build OpenSSL
# OPENSSL_VERSION=1.1.1w
# OPENSSL_ARCHIVE=openssl-$OPENSSL_VERSION.tar.gz
# OPENSSL_URI=https://www.openssl.org/source/$OPENSSL_ARCHIVE

# cd /workspaces
# curl -L -O $OPENSSL_URI && tar xf $OPENSSL_ARCHIVE && rm $OPENSSL_ARCHIVE

# cd /workspaces/openssl-$OPENSSL_VERSION
# export  PATH=$TOOLCHAIN/bin:$PATH && \
#     ./Configure no-shared --prefix=$PREFIX linux-aarch64 && \
#     make -j$(nproc) && make install_sw

# # Build libexpat
# LIBEXPAT_VERSION=2.5.0
# LIBEXPAT_ARCHIVE=expat-$LIBEXPAT_VERSION.tar.bz2
# LIBEXPAT_URI=https://github.com/libexpat/libexpat/releases/download/R_2_5_0/$LIBEXPAT_ARCHIVE

# cd /workspaces
# curl -L -O $LIBEXPAT_URI && tar xf $LIBEXPAT_ARCHIVE && rm $LIBEXPAT_ARCHIVE

# cd /workspaces/expat-$LIBEXPAT_VERSION
# ./configure \
#   --host=$HOST \
#   --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` \
#   --prefix=$PREFIX \
#   --disable-shared && \
#   make -j$(nproc) install


# # Build libssh2
# LIBSSH2_VERSION=1.11.0
# LIBSSH2_ARCHIVE=libssh2-$LIBSSH2_VERSION.tar.bz2
# LIBSSH2_URI=https://libssh2.org/download/$LIBSSH2_ARCHIVE

# cd /workspaces
# curl -L -O $LIBSSH2_URI && tar xf $LIBSSH2_ARCHIVE && rm $LIBSSH2_ARCHIVE

# cd /workspaces/libssh2-$LIBSSH2_VERSION
# ./configure \
#   --host=$HOST \
#   --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` \
#   --prefix=$PREFIX \
#   --disable-shared && \
#   make -j$(nproc) install

#sudo apt install -y autopoint
# autoreconf -vif

# Build aria2
cd /workspaces/aria2
./configure --prefix=$PREFIX \
  --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` \
  --host=$HOST \
  --disable-nls \
  --without-gnutls \
  -without-sqlite3 \
  --without-libxml2 \
  --with-libexpat \
  --with-libcares \
  --with-libz \
  --with-libssh2 \
  CXXFLAGS="-Os -g  -std=c++14" \
  CFLAGS="-Os -g" \
  CPPFLAGS="-fPIE" \
  LDFLAGS="-fPIE -pie -L$PREFIX/lib -static-libstdc++" \
  PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig" &&\
  make -j$(nproc) && \
  $STRIP src/aria2c
  mv src/aria2c $PREFIX/bin/