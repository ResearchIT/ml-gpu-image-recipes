#!/usr/bin/bash
CUDA_VERSION=11-0
TENSORRT_RPM=nv-tensorrt-repo-rhel7-cuda11.0-trt7.2.3.4-ga-20210226-1-1.x86_64.rpm
TENSORRT_VERSION=7
TENSOR_MINOR=2.3
set -e
cat << EOF > /etc/yum.repos.d/nvidia.repo
[cuda]
name=cuda
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64
enabled=1
gpgcheck=1
gpgkey=http://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64/7fa2af80.pub

[nvidia-machine-learning]
name=nvidia-machine-learning
baseurl=http://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64//7fa2af80.pub
obsoletes=0

[nvidia-ml]
name=nvidia-ml
baseurl=https://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64
enabled=1
gpgcheck=1
gpgkey=http://developer.download.nvidia.com/compute/machine-learning/repos/rhel8/x86_64/7fa2af80.pub
EOF

dnf install -y epel-release dnf-plugins-core yum-utils
dnf config-manager --set-enabled powertools
dnf install -y /$TENSORRT_RPM
rm -f /$TENSORRT_RPM
dnf update -y
dnf install -y gcc gcc-c++ gcc-gfortran autoconf automake binutils gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config cmake
dnf install -y --exclude=libX* --exclude=nvidia-driver* --exclude=cuda-drivers* --exclude=cuda-runtime* --exclude=cuda-toolkit-* --exclude=cuda-tools-* --exclude=cuda-visual-tools* --exclude=cuda-demo-suite* --exclude=cuda-samples* --exclude=cuda-nsight* --exclude=cuda-nvvp* --exclude=cuda-documentation* --exclude=cuda-11* cuda-*${CUDA_VERSION}* libcublas-devel-${CUDA_VERSION} libcublas-${CUDA_VERSION} libcufft-${CUDA_VERSION} libcufft-devel-${CUDA_VERSION} libcurand-${CUDA_VERSION} libcurand-devel-${CUDA_VERSION} libcusolver-${CUDA_VERSION} libcusolver-devel-${CUDA_VERSION} libcusparse-${CUDA_VERSION} libcusparse-devel-${CUDA_VERSION} libnvinfer$TENSORRT_VERSION libnvinfer-plugin$TENSORRT_VERSION libnvparsers$TENSORRT_VERSION libnvparsers-devel-${TENSORRT_VERSION}.${TENSOR_MINOR} libnvonnxparsers$TENSORRT_VERSION libnvonnxparsers-devel-${TENSORRT_VERSION}.${TENSOR_MINOR} libnvinfer-plugin-devel-${TENSORRT_VERSION}.${TENSOR_MINOR}-1.cuda${CUDA_VERSION/-/.} libnvinfer-devel-${TENSORRT_VERSION}.${TENSOR_MINOR}-1.cuda${CUDA_VERSION/-/.} *nccl*cuda11.0*
dnf remove -y ${TENSORRT_RPM/.rpm/}
ln -s /usr/local/cuda-11.0 /usr/local/cuda
dnf clean all
rm -rf /var/cache/dnf/*
set +e
