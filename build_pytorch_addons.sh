container=$(buildah from --ulimit nofile=8192:8192 localhost/centos8-cuda11.7-cudnn8-tensorrt8-python310-tensorflow-pytorch:latest)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
set -e
buildah copy $container install_pytorch_addons.sh /
buildah run $container bash /install_pytorch_addons.sh
buildah run $container bash -c "dnf clean all && rm -rf /*.sh /repo /build /var/cache/dnf/* /root/.cache/bazel /tmp/*"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=centos8-cuda11.6-cudnn8-tensorrt8-python39-tensorflow-pytorch-pytorchaddons $container
buildah commit $container centos8-cuda11.6-cudnn8-tensorrt8-python39-tensorflow-pytorch-pytorchaddons
buildah rm $container
unset container
set +e

