container=$(buildah from --ulimit nofile=8192:8192 nvcr.io/nvidia/tensorflow:22.08-tf2-py3)
trap 'cleanup' ERR
cleanup() {
	echo "Build failed, cleaning up."
	buildah rm $container
	exit 1
}
set -e
buildah copy $container install_pytorch.sh /
buildah run $container bash /install_pytorch.sh
buildah run $container bash -c "rm -rf /*.sh /repo /build /var/cache/dnf/* /root/.cache/bazel /tmp/*"
buildah config --created-by "snehring@iastate.edu" --author "snehring" --label name=ngc-tensorflow-pytorch $container
buildah commit $container ngc-tensorflow-pytorch
buildah rm $container
unset container
set +e

