# i2gpu_gketests

## Publications
Links
-----
- [FPGAs-as-a-Service Toolkit (FaaST)](https://arxiv.org/abs/2010.08556)
- [GPU-accelerated machine learning inference as a service for computing in neutrino experiments](https://arxiv.org/abs/2009.04509)
- [GPU coprocessors as a service for deep learning inference in high energy physics](https://arxiv.org/abs/2007.10359)
- [Applications and Techniques for Fast Machine Learning in Science](https://arxiv.org/abs/2110.13041)

## Introduction
Tests were performed from several client styles (Cloud-Cloud FNAL-Cloud MIT-Cloud) to a TRT server deployed on GKE

##  ailab-inference GKE cluster
* Master version: 1.15.9-gke.24
* Master zone: us-central1-a
* Node zones: us-central1-a, us-central1-f
* VPC-native (alias IP):Enabled
* Pod address range: 10.24.0.0/14
* Default maximum pods per node: 110
* Service address range: 10.0.0.0/20

### GKE Node pools

| Use                       | Pool Name            | Machine type   | OS                           | GPU model         | # GPUs | Instance template                              |
|---------------------------|----------------------|----------------|------------------------------|-------------------|--------|------------------------------------------------|
| Kubernetes core workloads | cpuonly-pool         | n1-standard-4  | Container-Optimized OS (cos) | N/a               | N/a    | gke-ailab-inference-cpuonly-pool-0f0dbec1      |
| ProtoDune                 | gpu-4-t4-boot        | n1-standard-4  | Container-Optimized OS (cos) | NVIDIA Tesla T4   | 4      | gke-ailab-inference-gpu-4-t4-boot-14e2482b     |
| CMS                       | gpu-v100-cos-himem   | n1-standard-16 | Container-Optimized OS (cos) | NVIDIA Tesla V100 | 4      | gke-ailab-inference-gpu-v100-cos-hime-42b578a6 |
| CMS                       | gpu-8-v100-cos-himem | n1-standard-16 | Container-Optimized OS (cos) | NVIDIA Tesla V100 | 8      | gke-ailab-inference-gpu-8-v100-cos-hi-2a214dda |

### GCE Instance Groups

| Node pool            | Instance grp (central-1f)                          | Instance grp (central-1a)                          | Template                                       |
|----------------------|----------------------------------------------------|----------------------------------------------------|------------------------------------------------|
| cpuonly-pool         | gke-ailab-inference-cpuonly-pool-1615bf50-grp      | gke-ailab-inference-cpuonly-pool-43548431-grp      | gke-ailab-inference-cpuonly-pool-0f0dbec1      |
| gpu-4-t4-boot        | gke-ailab-inference-gpu-4-t4-boot-5e8115ec-grp     | gke-ailab-inference-gpu-4-t4-boot-14e2482b-grp     | gke-ailab-inference-gpu-4-t4-boot-14e2482b     |
| gpu-8-v100-cos-himem | gke-ailab-inference-gpu-8-v100-cos-hi-f6c70a6f-grp | gke-ailab-inference-gpu-8-v100-cos-hi-2a214dda-grp | gke-ailab-inference-gpu-v100-cos-hime-42b578a6 |
| gpu-v100-cos-himem   | gke-ailab-inference-gpu-v100-cos-hime-57e34068-grp | gke-ailab-inference-gpu-v100-cos-hime-42b578a6-grp | gke-ailab-inference-gpu-8-v100-cos-hi-2a214dda |

### Public endpoints

| In use by | Public LB IP   | GPU type | Ports          |
|-----------|----------------|----------|----------------|
| ProtoDUNE | 34.70.127.245  | T4       | 8000,8001,8002 |
| CMS       | 35.224.243.148 | V100     | 8000,8001,8002 |
