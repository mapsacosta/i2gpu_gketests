#!/bin/bash

i=1

for dir in $(find ~/Desktop/GCO/repos/sonic-models/models -maxdepth 1 -mindepth 1 -type d | awk -F '/' '{print $9}')
do
  export server_name="triton0$i"
  echo "Creating $server_name for $dir"
  echo "$server_name,$dir" >> out
  export owner=$(whoami)
  export model_dir=gs://sonic-model-repo/sonic-7-yongbin/${server_name}/model_repository/
  ((i=i+1))
  envsubst < tensorrt-inference-server-v100.template > ${server_name}-server.yaml
  kubectl create -f ${server_name}-server.yaml
  until [ -n "$(kubectl get svc ${server_name}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
    sleep 5
  done
  svc_ip=$(kubectl get svc ${server_name}-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  echo "$server_name,$dir,$svc_ip"
done
