PYTHON_PACKAGES="keras pillow scikit-learn pandas pandas_ml matplotlib>=3.0.0 mxnet mlxtend tensorboard jupyter jupyterlab numba librosa soundfile cupy-cuda110"
dnf install -y libgomp libsndfile libsndfile-devel libvorbis libvorbis-devel flac-libs flac-devel libmad libmad-devel lame-libs lame-devel opus opus-devel sox sox-devel opencv* openblas openblas-devel libjpeg-turbo-devel libpng-devel libpng libjpeg-turbo libcurl libcurl-devel gnutls gnutls-devel libxml2 libxml2-devel 
python3 -m pip install $PYTHON_PACKAGES
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
#install.packages("tidyselect", repos="https://mirror.las.iastate.edu/CRAN/")
library(devtools)
devtools::install_github("rstudio/tensorflow")
library(tensorflow)
try(devtools::install_github("rstudio/keras"))
library(keras)
EOL