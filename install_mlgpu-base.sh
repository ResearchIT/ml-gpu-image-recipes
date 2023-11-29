PYTHON_PACKAGES="keras pillow scikit-learn pandas pandas_ml matplotlib>=3.0.0 mxnet-cu117 mlxtend tensorboard jupyter jupyterlab numba librosa soundfile cupy-cuda11x "
dnf install -y --allowerasing libgomp libsndfile libsndfile-devel libvorbis libvorbis-devel flac-libs flac-devel libmad libmad-devel \
lame-libs lame-devel opus opus-devel sox sox-devel opencv* openblas openblas-devel libjpeg-turbo-devel libpng-devel \
libpng libjpeg-turbo libcurl libcurl-devel gnutls gnutls-devel libxml2 libxml2-devel harfbuzz-devel harfbuzz \
fribidi-devel fribidi freetype-devel libpng-devel libtiff-devel libjpeg-turbo-devel
python3 -m pip install $PYTHON_PACKAGES
ln -s /usr/bin/python3 /usr/bin/python
#mkdir /build
#cd /build
#git clone https://github.com/google/jax
#cd jax
#git checkout -b v0.2.21
#python3 build/build.py --enable_cuda
#python3 -m pip install dist/*.whl
#python3 -m pip install .
python -m pip install "jax[cuda11_cudnn86]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# install R
## Turn off nodoc as that ruins R apparently
# sed -i 's/tsflags=nodocs//g' /etc/yum.conf
# or use --setopt=tsflags= to do it per invocation
#dnf config-manager --set-enabled PowerTools
dnf install -y --setopt=tsflags= R-core
dnf install -y R-core-devel R-devel R-Rcpp R-Rcpp-devel
R --no-save <<EOL
install.packages("pkgbuild", repos="https://mirror.las.iastate.edu/CRAN/")
install.packages("devtools", repos="https://mirror.las.iastate.edu/CRAN/")
#options(devtools.install.args = c("--no-multiarch", "--no-test-load", "--no-html","--nodoc"))
install.packages("tidyselect", repos="https://mirror.las.iastate.edu/CRAN/")
library(devtools)
devtools::install_github("rstudio/tensorflow")
library(tensorflow)
try(devtools::install_github("rstudio/keras"))
library(keras)
EOL
dnf install -y git 
export TORCH_CUDA_ARCH_LIST="6.1+PTX 7.0+PTX 7.5+PTX 8.0+PTX"
export KERAS_BACKEND=tensorflow
export CUDADIR=/usr/local/cuda-11.8
export CUDA_HOME=$CUDADIR
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64
# export MAGMA_HOME=/opt/magma
export FORCE_CUDA=1

python3 -m pip install scipy pip 'setuptools<60'
python3 -m pip install opencv-python
python3 -m pip install git+https://github.com/rusty1s/pytorch_scatter@master
python3 -m pip install git+https://github.com/rusty1s/pytorch_sparse@master
python3 -m pip install git+https://github.com/rusty1s/pytorch_cluster@master
python3 -m pip install git+https://github.com/rusty1s/pytorch_spline_conv@master
python3 -m pip install git+https://github.com/pyg-team/pytorch_geometric@master
python3 -m pip install ogb
#python3 -m pip install dgl-cu116 -f https://data.dgl.ai/wheels/repo.html
#dgl source build
mkdir /build
cd  /build
git clone --recurse-submodules https://github.com/dmlc/dgl.git
cd dgl
mkdir build
cd build
cmake -DUSE_CUDA=ON ..
make -j4
cd ../python
python3 setup.py install

#cleanup
cd /
yum clean all
rm -rf /var/cache/dnf/*
rm -rf /build

