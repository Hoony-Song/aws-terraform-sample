

# Init containers to add to the Velero deployment's pod spec. At least one plugin provider image is required.
# If the value is a string then it is evaluated as a template.
initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.8.0
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins

configuration:
  # Parameters for the BackupStorageLocation(s). Configure multiple by adding other element(s) to the backupStorageLocation slice.
  # See https://velero.io/docs/v1.6/api-types/backupstoragelocation/
  backupStorageLocation:
    # name is the name of the backup storage location where backups should be stored. If a name is not provided,
    # a backup storage location will be created with the name "default". Optional.
  - name: 
    # provider is the name for the backup storage location provider.
    provider: aws
    # bucket is the name of the bucket to store backups in. Required.
    bucket: ${velero_bucketname}
    # caCert defines a base64 encoded CA bundle to use when verifying TLS connections to the provider. Optional.
    caCert:
    # prefix is the directory under which all Velero data should be stored within the bucket. Optional.
    prefix: velero/${workspace}/eks
    # default indicates this location is the default backup storage location. Optional.
    default: true
    # validationFrequency defines how frequently Velero should validate the object storage. Optional.
    validationFrequency:
    # accessMode determines if velero can write to this backup storage location. Optional.
    # default to ReadWrite, ReadOnly is used during migrations and restores.
    accessMode: ReadWrite
    config:
      region: ap-northeast-2
    

  # Parameters for the VolumeSnapshotLocation(s). Configure multiple by adding other element(s) to the volumeSnapshotLocation slice.
  # See https://velero.io/docs/v1.6/api-types/volumesnapshotlocation/
  volumeSnapshotLocation:
    # name is the name of the volume snapshot location where snapshots are being taken. Required.
  - name:
    # provider is the name for the volume snapshot provider.
    provider: aws
    config:
      region: ap-northeast-2
  

rbac:
  # Whether to create the Velero role and role binding to give all permissions to the namespace to Velero.
  create: true
  # Whether to create the cluster role binding to give administrator permissions to Velero
  clusterAdministrator: true
  # Name of the ClusterRole.
  clusterAdministratorName: cluster-admin

credentials:
  secretContents:
    cloud: |
      [default]
      aws_access_key_id=${access_key}
      aws_secret_access_key=${secret_key}


# Backup schedules to create.
# Eg:
# schedules:
#   mybackup:
#     disabled: false
#     labels:
#       myenv: foo
#     annotations:
#       myenv: foo
#     schedule: "0 0 * * *"
#     useOwnerReferencesInBackup: false
#     template:
#       ttl: "240h"
#       storageLocation: default
#       includedNamespaces:
#       - foo
schedules: {}

# Velero ConfigMaps.
# Eg:
# configMaps:
    # See: https://velero.io/docs/v1.11/file-system-backup/
#   fs-restore-action-config:
#     labels:
#       velero.io/plugin-config: ""
#       velero.io/pod-volume-restore: RestoreItemAction
#     data:
#       image: velero/velero-restore-helper:v1.10.2
#       cpuRequest: 200m
#       memRequest: 128Mi
#       cpuLimit: 200m
#       memLimit: 128Mi
#       secCtx: |
#         capabilities:
#           drop:
#           - ALL
#           add: []
#         allowPrivilegeEscalation: false
#         readOnlyRootFilesystem: true
#         runAsUser: 1001
#         runAsGroup: 999
configMaps: {}

##
## End of additional Velero resource settings.
##
