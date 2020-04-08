# i2gpu_gketests
Tests were performed from several client styles (Cloud-Cloud FNAL-Cloud MIT-Cloud) to a TRT server deployed on GKE

##  ailab-inference GKE cluster
* Master version: 1.15.9-gke.24
* Master zone: us-central1-a
* Node zones: us-central1-a, us-central1-f
* VPC-native (alias IP):Enabled
* Pod address range: 10.24.0.0/14
* Default maximum pods per node: 110
* Service address range: 10.0.0.0/20

### Node pools

| Use                       | Pool Name            | Machine type   | OS                           | GPU model         | # GPUs |
|---------------------------|----------------------|----------------|------------------------------|-------------------|--------|
| Kubernetes core workloads | cpuonly-pool         | n1-standard-4  | Container-Optimized OS (cos) | N/a               | N/a    |
| ProtoDune                 | gpu-4-t4-boot        | n1-standard-4  | Container-Optimized OS (cos) | NVIDIA Tesla T4   | 4      |
| CMS                       | gpu-v100-cos-himem   | n1-standard-16 | Container-Optimized OS (cos) | NVIDIA Tesla V100 | 4      |
| CMS                       | gpu-8-v100-cos-himem | n1-standard-16 | Container-Optimized OS (cos) | NVIDIA Tesla V100 | 8      |

### Public endpoints

| In use by | Public LB IP   | GPU type | Ports          |
|-----------|----------------|----------|----------------|
| ProtoDUNE | 34.70.127.245  | T4       | 8000,8001,8002 |
| CMS       | 35.224.243.148 | V100     | 8000,8001,8002 |
