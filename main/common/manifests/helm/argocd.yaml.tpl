nameOverride: argocd
crds:
  install: true

global:
  revisionHistoryLimit: 3
  logging:
    format: text
    # -- Set the global logging level. One of: `debug`, `info`, `warn` or `error`
    level: info

  # -- Add Prometheus scrape annotations to all metrics services. This can be used as an alternative to the ServiceMonitors.
  addPrometheusAnnotations: false  # 수정 필요 false -> true

  # -- Environment variables to pass to all deployed Deployments
  env: []
configs:
  cm:
    create: true
    url: ${domain}  # 수정
  secret:
    # Tobe1234
    argocdServerAdminPassword: "$2y$10$aUV9tuxqqZhbZg.L6.MTbeIFl5kuqWDUcGIMZJTzTZtUIp/8UDVki"
  params:
    create: true

server:
  extraArgs:
  - --enable-gzip
  name: server
  replicas: 2
  service:
    type: NodePort
    servicePortHttp: 80
    servicePortHttps: 443
    servicePortHttpName: http
    servicePortHttpsName: https
  ## Server metrics service configuration
  metrics:
    # -- Deploy metrics service
    enabled: false
    service:
      type: ClusterIP
  ingress:
    enabled: true
    ingressClassName: "alb"
    annotations:
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
      alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
      alb.ingress.kubernetes.io/tags: "Area=dev,Owner=tobesoft,Project=nexacro-deploy"
      external-dns.alpha.kubernetes.io/hostname: ${domain}
    hosts:
      - ${domain}
    paths:
      - /
    pathType: Prefix
    https: false

  ingressGrpc:
    enabled: false
    isAWSALB: true
    annotations:
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/conditions.argogrpc: |
        [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "Content-Type", "values":["application/grpc"]}}]
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
      external-dns.alpha.kubernetes.io/hostname: ${domain}
    ingressClassName: "alb"
    awsALB:
      serviceType: ClusterIP
      backendProtocolVersion: HTTP2
    hosts:
     - ${domain}
    paths:
      - /
    pathType: Prefix
    https: false

