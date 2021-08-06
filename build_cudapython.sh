container=$(buildah from localhost/centos8-cuda11.0-cudnn8-tensorrt7:latest)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
buildah copy $container TensorRT-7.2.3.4.CentOS-7.9.x86_64-gnu.cuda-11.0.cudnn8.1.tar.gz /repo/
buildah copy $container install_python.sh /
buildah run $container bash /install_python.sh
buildah run $container bash -c "dnf clean all && rm -rf /*.sh /repo /build /var/cache/dnf/*"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=centos8-cuda11.0-cudnn8-tensorrt7-python38 $container
buildah commit $container centos8-cuda11.0-cudnn8-tensorrt7-python38
buildah rm $container
unset container

