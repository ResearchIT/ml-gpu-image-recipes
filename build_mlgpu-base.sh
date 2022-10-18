container=$(buildah from --ulimit nofile=8192:8192 localhost/centos8-cuda11.7-cudnn8-tensorrt8-python310-tensorflow-pytorch:latest)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
buildah copy $container install_mlgpu-base.sh /
buildah run $container bash /install_mlgpu-base.sh
buildah run $container bash -c "dnf clean all && rm -rf /*.sh /repo /build /var/cache/dnf/* /root/.cache/bazel /tmp/* /root/.cache"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=ml-gpu-base $container
buildah commit $container ml-gpu-base
buildah rm $container
unset container

