#!/usr/bin/env bash
set -e
export CUDADIR=/usr/local/cuda
export CUDACXX=/usr/local/cuda/bin/nvcc
# patch is extremely required by one of the torchaudio deps
# and it absolutely will fail with no indication of why without it
dnf install -y diffutils cmake pkg-config patch
mkdir /build
# kineto
# ugh
export CUDA_SOURCE_DIR=$CUDADIR
cd /build
git clone --recursive --branch v0.4.0 https://github.com/pytorch/kineto.git
cd kineto/libkineto
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DKINETO_BUILD_TESTS=false ..
make -j16
make install
# torchvision
cd /build
git clone --recursive --branch v0.12.0 https://github.com/pytorch/vision.git torchvision
cd torchvision
python3 setup.py install
#python3 -m pip install .
cd /build
# torchaudio
git clone --recursive --branch master https://github.com/pytorch/audio.git torchaudio
cd torchaudio
python3 setup.py install
#python3 -m pip install .
cd /build
dnf remove -y git ninja-build
dnf clean all
set +e
