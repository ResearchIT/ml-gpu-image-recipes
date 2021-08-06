set -e
mkdir /build
dnf install -y openssl-devel libffi-devel git bzip2-devel xz-devel sqlite-devel readline-devel ncurses-devel tk-devel uuid-devel
cd /build
curl -LO https://www.python.org/ftp/python/3.8.11/Python-3.8.11.tgz
tar -xzf Python-3.8.11.tgz
cd Python-3.8.11
CFLAGS="-march=haswell -O3 -fPIC" LDFLAGS='-Wl,-rpath=/opt/python38/lib' CXXFLAGS=$CFLAGS ./configure --enable-optimizations --with-threads --enable-shared --prefix=/opt/python38
make -j16
make install
alternatives --install /usr/bin/python3 python3 /opt/python38/bin/python3 1024
alternatives --set python3 /opt/python38/bin/python3
cd /build
tar -xzf /repo/TensorRT-7.2.3.4.CentOS-7.9.x86_64-gnu.cuda-11.0.cudnn8.1.tar.gz
python3 -m pip install TensorRT-7.2.3.4/python/tensorrt-7.2.3.4-cp38-none-linux_x86_64.whl
rm -rf /build/{Python3.9.6,trt,TensorRT*}
dnf remove -y git
cd /
set +e
