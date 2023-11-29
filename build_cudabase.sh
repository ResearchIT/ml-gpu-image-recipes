container=$(buildah from quay.io/centos/centos:stream9)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
buildah copy $container TensorRT-8.5.3.1.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz /
buildah copy $container install_cuda_base.sh /
buildah run $container bash /install_cuda_base.sh
buildah run $container rm -rf /*.sh /build
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=centos9-cuda11.8-cudnn8-tensorrt8 $container
buildah commit $container centos9-cuda11.8-cudnn8-tensorrt8
buildah rm $container
unset container

