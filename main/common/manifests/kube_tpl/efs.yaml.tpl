apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-sc
parameters:
  # 권한
  directoryPerms: "755"
  fileSystemId: ${efs_id}
  provisioningMode: efs-ap
provisioner: efs.csi.aws.com