#!/bin/bash

# @author. Maria AcostaFlechas  (acostaflechas@protonmail.ch)

while getopts 's:m:u:' flag; do
  case "${flag}" in
    s) export TRITON_SERVER_NAME="${OPTARG}"
       ;;
    u) TRITON_OWNER_USERNAME="${OPTARG}"
       ;;
    m) export MODEL_GCS_BUCKET="${OPTARG}"
       ;;
    h) echo "Usage: $0"
       echo "Optional: -s [<TritonRT server name (DNS safe)>] -u [<usename>] -m [<Model repo path (GCS bucket)]"
       ;;
  esac
done

# Parameter validation
[ -z ${TRITON_SERVER_NAME} ] && echo "Error please enter server name" && exit 1
[ -z ${MODEL_GCS_BUCKET} ] && echo "Error please enter Model Repository" && exit 1

if [ -n $TRITON_OWNER_USERNAME ]
then
  export TRITON_OWNER_USERNAME=$(whoami)
fi

echo "Creating ${TRITON_SERVER_NAME} (${TRITON_OWNER_USERNAME})"
envsubst '${TRITON_SERVER_NAME},${TRITON_OWNER_USERNAME},${MODEL_GCS_BUCKET}' < triton-inference-server.template > ./${TRITON_SERVER_NAME}.yaml
cat ./${TRITON_SERVER_NAME}.yaml
kubectl create -f ${TRITON_SERVER_NAME}.yaml

echo "Waiting for the service to become active.."
until [ -n "$(kubectl get svc ${TRITON_SERVER_NAME}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
  sleep 5
done
svc_ip=$(kubectl get svc ${TRITON_SERVER_NAME}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Done, your tritonRT server can be reached at ${svc_ip}"
echo "${TRITON_SERVER_NAME} -> ${svc_ip}"
