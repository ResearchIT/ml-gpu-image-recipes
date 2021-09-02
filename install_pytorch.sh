#!/usr/bin/env bash
CUDADIR=/usr/local/cuda
PYTORCH_NEEDS="cffi typing_extensions future six requests dataclasses pillow-simd pyyaml"
dnf install -y libgomp git libsndfile libsndfile-devel libvorbis libvorbis-devel flac-libs flac-devel libmad libmad-devel lame-libs lame-devel opus opus-devel sox sox-devel opencv* openblas openblas-devel libjpeg-turbo-devel libpng-devel libpng libjpeg-turbo ninja-build
mkdir /build
cd /build
# BEGIN MAGMA
export PATH=$PATH:${CUDADIR}/bin
mkdir magma
cd magma
curl -L http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.1.tar.gz | tar -xz
cd magma-2.6.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDADIR}/lib64
cp make.inc-examples/make.inc.openblas make.inc
sed -i 's/GPU_TARGET =.*/GPU_TARGET = sm_61 sm_70 sm_75 sm_80/' make.inc
export OPENBLASDIR=/usr
export BACKEND=cuda
LIBRARY_PATH=/usr/local/cuda/lib64 make -j16
make install prefix=/opt/magma
export MAGMA_HOME=/opt/magma
unset OPENBLASDIR
unset BACKEND
# END MAGMA
cd /build

# BEGIN PYTORCH
# Pytorch stuff
#python3 -m pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
# from source
python3 -m pip install $PYTORCH_NEEDS numpy wheel
git clone --recursive --branch v1.9.0 https://github.com/pytorch/pytorch
cd pytorch
git submodule sync
git submodule update --init --recursive --jobs 0
python setup.py install
# kineto
cd /build
git clone --recursive --branch v0.2.1 https://github.com/pytorch/kineto.git
cd kineto
git submodule sync --recursive
git submodule update --init --force --recursive --depth 1
mkdir build_static
cd build_static
cmake -DKINETO_LIBRARY_TYPE=static -DCMAKE_INSTALL_PREFIX=/usr ../libkineto/
make -j16
make install
cd ..
mkdir build_shared
cd build_shared
cmake -DKINETO_LIBRARY_TYPE=shared -DCMAKE_INSTALL_PREFIX=/usr ../libkineto/
make -j16
make install
# torchvision
cd /build
git clone --recursive --branch v0.10.0 https://github.com/pytorch/vision.git torchvision
cd torchvision
python setup.py install
cd /build
# torchaudio
git clone --recursive --branch v0.9.0 https://github.com/pytorch/audio.git torchaudio
cd torchaudio
python setup.py install
cd /build
dnf remove -y git ninja-build
dnf clean all
