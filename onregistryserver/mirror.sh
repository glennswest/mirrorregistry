echo "Mirroring " $1
export OCP_RELEASE=$1
export LOCAL_REGISTRY='registry.gw.lo:8443'
export LOCAL_REPOSITORY='ocp4/openshift4'
export PRODUCT_REPO='openshift-release-dev'
export LOCAL_SECRET_JSON='/home/registry/pull-secret.txt'
export RELEASE_NAME="ocp-release"
export ARCHITECTURE='x86_64'
export REMOVABLE_MEDIA_PATH='/home/registry/images'
podman login -u init -p Ts3Fz4M2BbUY08icf76rGae1m9LhuXW5 registry.gw.lo:8443 --tls-verify=false
oc adm release mirror -a ${LOCAL_SECRET_JSON} --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} --dry-run > dryrun.out
oc adm release mirror -a ${LOCAL_SECRET_JSON} --to-dir=${REMOVABLE_MEDIA_PATH}/mirror quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} > copylocal.out
oc image mirror  --insecure=true -a ${LOCAL_SECRET_JSON} --from-dir=${REMOVABLE_MEDIA_PATH}/mirror "file://openshift/release:${OCP_RELEASE}*" ${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} > copyregistry.out
oc adm release extract --insecure=true -a ${LOCAL_SECRET_JSON} --command=openshift-install "${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}"
rm -r -f /home/registry/images



