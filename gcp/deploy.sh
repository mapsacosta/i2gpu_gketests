#!/bin/bash

#CHANGE ME - Meaningful name for your deployment
export server_name="tritonrt-server"

#CHANGE ME - Your name/username for avoiding confusions
export owner=$(whoami)

#CHANGE ME - Point this variable to the model repository to use.
#            Needs to be an already existing GCS bucket in the HarrisGroup project

export model_dir=gs://sonic-model-repo/model_repository

echo "Creating $server_name"
envsubst < tensorrt-inference-server-v100.template > ${server_name}-server.yaml
kubectl create -f ${server_name}-server.yaml

echo "Waiting for the service to become active.."
until [ -n "$(kubectl get svc ${server_name}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
  sleep 5
done
svc_ip=$(kubectl get svc ${server_name}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Done, your tritonRT server can be reached at ${svc_ip}"
echo "${server_name} -> ${svc_ip}"
