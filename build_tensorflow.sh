container=$(buildah from --ulimit nofile=8192:8192 localhost/centos9-cuda11.8-cudnn8-tensorrt8-python310:latest)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
#buildah copy $container install_tensorflow.sh /
#buildah run $container bash /install_tensorflow.sh
buildah copy $container install_tensorflow.sh
buildah run $container bash /install_tensorflow.sh
buildah run $container bash -c "dnf clean all && rm -rf /*.sh /repo /build /var/cache/dnf/* /root/.cache/bazel /tmp/*"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=centos9-cuda11.8-cudnn8-tensorrt8-python310-tensorflow $container
buildah commit $container centos9-cuda11.8-cudnn8-tensorrt8-python310-tensorflow
buildah rm $container
unset container

