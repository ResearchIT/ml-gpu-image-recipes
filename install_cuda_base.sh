#!/usr/bin/bash
CUDA_VERSION=11-8
CUDNN_VERSION=8
TENSORRT_TAR=TensorRT-8.5.3.1.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz
TENSORRT_VERSION=8
TENSOR_MINOR=4.3
set -e
cat << EOF > /etc/yum.repos.d/nvidia.repo
[cuda]
name=cuda
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64
enabled=1
gpgcheck=1
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/D42D0685.pub
EOF

dnf install -y epel-release dnf-plugins-core yum-utils
dnf config-manager --set-enabled crb
dnf update -y
dnf install -y gcc gcc-c++ gcc-gfortran autoconf automake binutils gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config cmake
dnf install -y --exclude='nvidia-driver*' --exclude='*cuda12*' --exclude='libcudnn8*8.9*' cuda-libraries-${CUDA_VERSION} cuda-libraries-devel-${CUDA_VERSION} cuda-cudart-${CUDA_VERSION} cuda-cudart-devel-${CUDA_VERSION} \
cuda-minimal-build-${CUDA_VERSION} cuda-driver-devel-${CUDA_VERSION} cuda-nv*-${CUDA_VERSION} cuda-compat-*${CUDA_VERSION}* libcublas-devel-${CUDA_VERSION} \
libcublas-${CUDA_VERSION} libcufft-${CUDA_VERSION} libcufft-devel-${CUDA_VERSION} cuda-cupti-${CUDA_VERSION} \
libcurand-${CUDA_VERSION} libcurand-devel-${CUDA_VERSION} libcusolver-${CUDA_VERSION} libcusolver-devel-${CUDA_VERSION} libcusparse-${CUDA_VERSION} \
libcusparse-devel-${CUDA_VERSION} libcudnn${CUDNN_VERSION} libcudnn${CUDNN_VERSION}-devel *nccl*cuda*
# tensorrt tar install
tar -xzf TensorRT-8.5.3.1.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz
CUDA_ROOT=/usr/local/cuda
pushd TensorRT-8.5.3.1
cd targets/x86_64-linux-gnu
cp -r lib/* ${CUDA_ROOT}/targets/x86_64-linux/lib/
cp -r bin/* ${CUDA_ROOT}/bin/
cd ../..
cp -r include/* ${CUDA_ROOT}/include/
popd
rm -rf /TensorRT-8.5.3.1.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz
rm -rf /TensorRT-8.5.3.1
# tensorrt libs
#dnf install -y libnvinfer$TENSORRT_VERSION libnvinfer-plugin$TENSORRT_VERSION libnvparsers$TENSORRT_VERSION libnvparsers-devel libnvonnxparsers${TENSORRT_VERSION} libnvonnxparsers-devel tensorrt libnvinfer-plugin-devel libnvinfer-devel
dnf clean all
rm -rf /var/cache/dnf/*
set +e
