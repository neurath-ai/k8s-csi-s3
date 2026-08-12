# Helm chart for csi-s3

This chart adds S3 volume support to your cluster.

## Install chart

```bash
helm install csi-s3 oci://registry-1.docker.io/dmorozoff/csi-s3 \
  --version 0.43.7-neurath.1 \
  --namespace kube-system \
  --set secret.accessKey=<YOUR_ACCESS_KEY> \
  --set secret.secretKey=<YOUR_SECRET_KEY> \
  --set secret.endpoint=<YOUR_S3_ENDPOINT>
```

After installation succeeds, you can get a status of Chart: `helm status csi-s3`.

## Delete Chart

- Helm 2.x: `helm delete --purge csi-s3`
- Helm 3.x: `helm uninstall csi-s3 --namespace kube-system`

## Configuration

By default, this chart creates a secret and a storage class. Set `secret.accessKey`, `secret.secretKey`, and
`secret.endpoint` for your S3-compatible service.

The following table lists all configuration parameters and their default values.

| Parameter                    | Description                                                            | Default                                                |
| ---------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------ |
| `storageClass.create`        | Specifies whether the storage class should be created                  | true                                                   |
| `storageClass.name`          | Storage class name                                                     | csi-s3                                                 |
| `storageClass.singleBucket`  | Use a single bucket for all dynamically provisioned persistent volumes |                                                        |
| `storageClass.mounter`       | Mounter to use. Either geesefs, s3fs or rclone. geesefs recommended    | geesefs                                                |
| `storageClass.mountOptions`  | GeeseFS mount options                                                  | `--memory-limit 1000 --dir-mode 0777 --file-mode 0666` |
| `storageClass.reclaimPolicy` | Volume reclaim policy                                                  | Delete                                                 |
| `storageClass.annotations`   | Annotations for the storage class                                      |                                                        |
| `secret.create`              | Specifies whether the secret should be created                         | true                                                   |
| `secret.name`                | Name of the secret                                                     | csi-s3-secret                                          |
| `secret.accessKey`           | S3 Access Key                                                          |                                                        |
| `secret.secretKey`           | S3 Secret Key                                                          |                                                        |
| `secret.endpoint`            | Endpoint                                                               |                                                        |
| `secret.region`              | Region                                                                 |                         |
| `tolerations.all`            | Tolerate all taints by the CSI-S3 node driver (mounter)                | false                                                  |
| `tolerations.node`           | Custom tolerations for the CSI-S3 node driver (mounter)                | []                                                     |
| `tolerations.controller`     | Custom tolerations for the CSI-S3 controller (provisioner)             | []                                                     |
