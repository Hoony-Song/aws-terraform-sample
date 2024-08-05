
global:
  imageRegistry: ""
  imagePullSecrets: []
  storageClass: ""

clusterDomain: cluster.local

auth:
  username: admin
  password: "Tobe1234"
  erlangCookie: "Tobe1234"
  securePassword: true

configuration: |-
  ## Username and password
  ##
  default_user = {{ .Values.auth.username }}
  {{- if and (not .Values.auth.securePassword) .Values.auth.password }}
  default_pass = {{ .Values.auth.password }}
  {{- end }}

persistence:
  size: 10Gi

service:
  type: ClusterIP
  portEnabled: true
  distPortEnabled: true
  managerPortEnabled: true
  epmdPortEnabled: true
  ports:
    amqp: 5672
    amqpTls: 5671
    dist: 25672
    manager: 15672
    metrics: 9419
    epmd: 4369
  portNames:
    amqp: "amqp"
    amqpTls: "amqp-tls"
    dist: "dist"
    manager: "http-stats"
    metrics: "metrics"
    epmd: "epmd"

ingress:
  enabled: true
  pathType: Prefix
  hostname: ${domain}
  annotations:
    alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    external-dns.alpha.kubernetes.io/hostname: ${domain}
    alb.ingress.kubernetes.io/target-type: ip
  ingressClassName: "alb"

volumePermissions:
  enabled: false
  image:
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 11-debian-11-r130
    digest: ""
    pullPolicy: IfNotPresent
    pullSecrets: []
  resources:
    limits: {}
    requests: {}
  containerSecurityContext:
    runAsUser: 0
