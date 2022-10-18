PYTHON_MAJOR=3
PYTHON_MINOR=10
PYTHON_PATCH=7
ARCH='haswell'
TRT_TARBALL=TensorRT-8.4.2.4.Linux.x86_64-gnu.cuda-11.6.cudnn8.4.tar.gz
TRT_WHEEL=TensorRT-8.4.2.4/python/tensorrt-8.4.2.4-cp310-none-linux_x86_64.whl
set -e
mkdir /build
dnf install -y openssl-devel libffi-devel git bzip2-devel xz-devel sqlite-devel readline-devel ncurses-devel tk-devel uuid-devel gcc-toolset-11
# ENABLE NEW GCC
source /opt/rh/gcc-toolset-11/enable
cd /build
curl -L https://www.python.org/ftp/python/${PYTHON_MAJOR}.${PYTHON_MINOR}.${PYTHON_PATCH}/Python-${PYTHON_MAJOR}.${PYTHON_MINOR}.${PYTHON_PATCH}.tgz | tar -xz
cd Python-${PYTHON_MAJOR}.${PYTHON_MINOR}.${PYTHON_PATCH}
CFLAGS="-march=${ARCH} -O3 -fPIC" LDFLAGS="-Wl,-rpath=/opt/python${PYTHON_MAJOR}${PYTHON_MINOR}/lib" CXXFLAGS=$CFLAGS ./configure --enable-optimizations --with-threads --enable-shared --prefix=/opt/python${PYTHON_MAJOR}${PYTHON_MINOR}
make -j16
make install
alternatives --install /usr/bin/python${PYTHON_MAJOR} python${PYTHON_MAJOR} /opt/python${PYTHON_MAJOR}${PYTHON_MINOR}/bin/python${PYTHON_MAJOR} 1024
alternatives --set python${PYTHON_MAJOR} /opt/python${PYTHON_MAJOR}${PYTHON_MINOR}/bin/python${PYTHON_MAJOR}
cd /build
tar -xzf /repo/${TRT_TARBALL}
python${PYTHON_MAJOR} -m pip install ${TRT_WHEEL}
rm -rf /build/{Python${PYTHON_MAJOR}.${PYTHON_MINOR}.${PYTHON_PATCH},trt,TensorRT*} /build /repo
dnf remove -y git
cd /
set +e
