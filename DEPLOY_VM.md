To start the Triton server in a baremetal GCP VM:
1. Create (or start) a cuda-enabled VM in GCP Compute Engine.
* See instructions on creating one here: https://cloud.google.com/compute/docs/gpus/create-vm-with-gpus#dlvm-image
* For our tests a VM simulates the conditions of the Triton server used for previous tests (Kubernetes-based) on an isolated machine. 
* Start the VM from the console: `triton-compute-tesla-t4`
2. Make sure to authenticate with the server. Follow the instructions on the prompt: 
```
gcloud auth login
```
3. Connect to the triton VM on HarrisGroup:
```
gcloud beta compute ssh --zone "us-central1-f" "triton-compute-tesla-t4" --project "harrisgroup-223921"
```
4. Make sure the model repository GCS bucket is mounted via gcsfuse, in this case at /home/$(whoami)/model_repository which is then bind mounted to the server container. 
5. Make sure the destination directoty exists, and finally mount the bucket via gcsfuse:
```
mkdir -p /home/$(whoami)/model_repository
gcsfuse sonic-model-repo /home/$(whoami)/model_repository
```
6. Start the server via Docker run:
```
docker run -d --gpus=4 --rm -p 8000:8000 -p 8001:8001 -p 8002:8002 -v type=bind,source=/home/$(whoami)/model_repository,target=/srv nvcr.io/nvidia/tritonserver:21.05-py3 tritonserver --model-repository=/srv
```
7. Find the VM external IP and use it as the host for your tests. The container is configured to expose HTTP on 8000, gRPC on 8001 and metrics on 8002:
```
gcloud compute instances describe triton-compute-tesla-t4 --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

Try to query the metrics endpoint. If the server started correctly, the following should work:
```
curl -vvv http://<vm_ip>:8002/metrics
```
