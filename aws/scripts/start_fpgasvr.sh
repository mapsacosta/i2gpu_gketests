#!/bin/bash

#This AWS host is low on disk so we first prune other images we're not using
echo "Pruning docker"
docker image prune -a

echo "Preparing  drivers..."
source /home/centos/aws-fpga/sdk_setup.sh
source /home/centos/aws-fpga/hdk_setup.sh
source /home/centos/aws-fpga/vitis_setup.sh
source /home/centos/aws-fpga/vitis_runtime_setup.sh
source /home/centos/aws-fpga/sdaccel_setup.sh
source /home/centos/aws-fpga/sdaccel_runtime_setup.sh

/opt/xilinx/xrt/bin/xbutil scan

# We run a xbutil scan to make sure cards are ready, if you don't see an error message then they are. 
# Type Y if they are ready, if not we will restart the mpd process and try again

read -p "Are cards ready?? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  /home/centos/grpc-fpga-trt-docker/docker_run.sh docker.io/holzman/grpc-trt-fpga:aws
else
  systemctl restart mpd
  /opt/xilinx/xrt/bin/xbutil scan
  /home/centos/grpc-fpga-trt-docker/docker_run.sh docker.io/holzman/grpc-trt-fpga:aws
fi

  echo "Done.."
  docker ps
