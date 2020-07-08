#!/bin/bash
echo "Pruning docker"
docker image prune -a

echo "Prepring  drivers..."
source ~/aws-fpga/sdk_setup.sh
source ~/aws-fpga/hdk_setup.sh
source ~/aws-fpga/vitis_setup.sh
source ~/aws-fpga/vitis_runtime_setup.sh
source ~/aws-fpga/sdaccel_setup.sh
source ~/aws-fpga/sdaccel_runtime_setup.sh

/opt/xilinx/xrt/bin/xbutil scan

read -p "Are cards ready?? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  /home/centos/grpc-fpga-trt-docker/docker_run.sh docker.io/holzman/grpc-trt-fpga-aws:haproxy
  # do dangerous stuff
else
  systemctl restart mpd
  /opt/xilinx/xrt/bin/xbutil scan
  /home/centos/grpc-fpga-trt-docker/docker_run.sh docker.io/holzman/grpc-trt-fpga-aws:haproxy
fi
