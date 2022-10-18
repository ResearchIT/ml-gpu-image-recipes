#!/usr/bin/bash
CUDA_VERSION=11-7
CUDNN_VERSION=8
TENSORRT_RPM=nv-tensorrt-repo-rhel8-cuda11.6-trt8.4.2.4-ga-20220720-1-1.x86_64.rpm
TENSORRT_VERSION=8
TENSOR_MINOR=4.3
set -e
cat << EOF > /etc/yum.repos.d/nvidia.repo
[cuda]
name=cuda
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64
enabled=1
gpgcheck=1
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/D42D0685.pub

[nvidia-machine-learning]
name=nvidia-machine-learning
baseurl=http://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/D42D0685.pub
obsoletes=0

[nvidia-ml]
name=nvidia-ml
baseurl=https://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64
enabled=1
gpgcheck=1
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/D42D0685.pub
EOF

dnf install -y epel-release dnf-plugins-core yum-utils
dnf config-manager --set-enabled powertools
dnf install -y /$TENSORRT_RPM
rm -f /$TENSORRT_RPM
dnf update -y
dnf install -y gcc gcc-c++ gcc-gfortran autoconf automake binutils gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config cmake
dnf install -y --exclude=nvidia-driver* cuda-libraries-${CUDA_VERSION} cuda-libraries-devel-${CUDA_VERSION} cuda-cudart-${CUDA_VERSION} cuda-cudart-devel-${CUDA_VERSION} \
cuda-minimal-build-${CUDA_VERSION} cuda-driver-devel-${CUDA_VERSION} cuda-nv*-${CUDA_VERSION} cuda-compat-*${CUDA_VERSION}* libcublas-devel-${CUDA_VERSION} \
libcublas-${CUDA_VERSION} libcufft-${CUDA_VERSION} libcufft-devel-${CUDA_VERSION} cuda-cupti-${CUDA_VERSION} \
libcurand-${CUDA_VERSION} libcurand-devel-${CUDA_VERSION} libcusolver-${CUDA_VERSION} libcusolver-devel-${CUDA_VERSION} libcusparse-${CUDA_VERSION} \
libcusparse-devel-${CUDA_VERSION} libnvinfer$TENSORRT_VERSION libnvinfer-plugin$TENSORRT_VERSION libnvparsers$TENSORRT_VERSION \
libnvparsers-devel libnvonnxparsers${TENSORRT_VERSION} libnvonnxparsers-devel tensorrt \
libnvinfer-plugin-devel libnvinfer-devel \
libcudnn${CUDNN_VERSION} libcudnn${CUDNN_VERSION}-devel *nccl*cuda*
dnf remove -y ${TENSORRT_RPM/.rpm/}
ln -s /usr/local/cuda-${CUDA_VERSION/-/.} /usr/local/cuda
dnf clean all
rm -rf /var/cache/dnf/*
set +e
