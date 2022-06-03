TENSORRT_VERSION=8
# whatever
ln -s /usr/bin/python3 /usr/bin/python
set -e
mkdir /build
dnf install -y git
curl -fL https://releases.bazel.build/5.1.1/release/bazel-5.1.1-linux-x86_64 -o /usr/bin/bazel
chmod +x /usr/bin/bazel
cd /build
#do tensorflow build here
python3 -m pip install numpy>=1.20.0 wheel packaging
python3 -m pip install keras_preprocessing --no-deps
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout r2.9
export BAZEL_SH=/usr/bin/bash
export PYTHON_BIN_PATH=/opt/python39/bin/python3
export PYTHON_LIB_PATH=/opt/python39/lib/python3.9/site-packages
export TF_NEED_TENSORRT=1
export TF_TENSORRT_VERSION=$TENSORRT_VERSION
export TF_TENSORRT_INSTALL_PATH=/usr
export TF_NEED_CUDA=1
export TF_NEED_ROCM=0
export TF_CUDA_TOOLKIT_PATH=/usr/local/cuda-11.6/
export TF_CUDA_COMPUTE_CAPABILITIES=6.1,7.0,7.5,8.0
export TF_CUDA_VERSION=11.6
export TF_NEED_JEMALLOC=1
export TF_CUDNN_VERSION=8
export TF_NCCL_VERSION=2
export TF_NEED_GCP=0
export TF_NEED_MPI=0
export TF_NEED_HDFS=0
export TF_NEED_OPENCL=0
export TF_ENABLE_XLA=0
export TF_NEED_VERBS=0
export TF_CUDA_CLANG=0
export TF_NEED_MKL=0
export TF_DOWNLOAD_MKL=0
export TF_NEED_AWS=0
export TF_NEED_MPI=0
export TF_NEED_GDR=0
export TF_NEED_S3=0
export TF_NEED_OPENCL_SYCL=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_NEED_COMPUTECPP=0
export TF_NEED_KAFKA=0
export GCC_HOST_COMPILER_PATH=$(which gcc)
export CC_OPT_FLAGS="-march=haswell -O3"
./configure
bazel build --config=cuda //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package ./output/tf/
python3 -m pip install ./output/tf/*.whl
dnf remove -y git
rm -rf /build/tensorflow
set +e
