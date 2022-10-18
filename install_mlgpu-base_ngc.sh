PYTHON_PACKAGES="keras pillow scikit-learn pandas pandas_ml matplotlib>=3.0.0 mxnet mlxtend tensorboard jupyter jupyterlab numba librosa soundfile cupy-cuda117 "
dnf install -y libgomp libsndfile libsndfile-devel libvorbis libvorbis-devel flac-libs flac-devel libmad libmad-devel \
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
python -m pip install "jax[cuda11_cudnn82]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

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
