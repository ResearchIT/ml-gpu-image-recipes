#!/usr/bin/bash
CUDA_VERSION=11-6
CUDNN_VERSION=8
TENSORRT_RPM=nv-tensorrt-repo-rhel8-cuda11.4-trt8.2.5.1-ga-20220505-1-1.x86_64.rpm
TENSORRT_VERSION=8
TENSOR_MINOR=2.5
set -e
dnf install -y epel-release dnf-plugins-core yum-utils
dnf config-manager --set-enabled powertools
dnf install -y /$TENSORRT_RPM
rm -f /$TENSORRT_RPM
dnf update -y
dnf install -y gcc gcc-c++ gcc-gfortran autoconf automake binutils gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config cmake
dnf install -y libnvinfer$TENSORRT_VERSION libnvinfer-plugin$TENSORRT_VERSION libnvparsers$TENSORRT_VERSION \
libnvparsers-devel libnvonnxparsers${TENSORRT_VERSION} libnvonnxparsers-devel tensorrt libnvinfer-plugin-devel libnvinfer-devel
dnf remove -y ${TENSORRT_RPM/.rpm/}
dnf clean all
rm -rf /var/cache/dnf/*
set +e
