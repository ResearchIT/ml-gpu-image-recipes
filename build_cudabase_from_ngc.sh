container=$(buildah from nvcr.io/nvidia/cuda:11.6.1-cudnn8-devel-rockylinux8)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
buildah copy $container nv-tensorrt-repo-rhel8-cuda11.4-trt8.2.5.1-ga-20220505-1-1.x86_64.rpm /
buildah copy $container install_tensorrt_on_cuda.sh /
buildah run $container bash /install_tensorrt_on_cuda.sh
buildah run $container rm -rf /*.sh /build
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=rockylinux8-cuda11.6-cudnn8-tensorrt8 $container
buildah commit $container rockylinux8-cuda11.6-cudnn8-tensorrt8
buildah rm $container
unset container

