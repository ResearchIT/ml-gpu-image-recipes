container=$(buildah from localhost/centos8-cuda11.6-cudnn8-tensorrt8:latest)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
set -e
buildah copy $container TensorRT-8.2.5.1.Linux.x86_64-gnu.cuda-11.4.cudnn8.2.tar.gz /repo/
buildah copy $container install_python.sh /
buildah run $container bash /install_python.sh
buildah run $container bash -c "dnf clean all && rm -rf /*.sh /repo /build /var/cache/dnf/*"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=centos8-cuda11.6-cudnn8-tensorrt8-python39 $container
buildah commit $container centos8-cuda11.6-cudnn8-tensorrt8-python39
buildah rm $container
unset container
set +e
