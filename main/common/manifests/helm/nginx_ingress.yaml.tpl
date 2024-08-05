serviceAccount:
  create: true
rbac:
  create: true

controller:
  image:
    allowPrivilegeEscalation: false
  replicaCount: 3
  service:
    externalTrafficPolicy: Local
    type: LoadBalancer
    annotations:
      # v2.2.0 release 이후 외부 노출시 internet-facing필요 https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/service/nlb/#network-load-balancer
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
      service.beta.kubernetes.io/aws-load-balancer-type: "external"
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "3600"
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
      # ACM 인증서 적용을 위하여 ARN 작성 필요
      # acm 인증서가 1개일 경우 
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${certificate_arn}
      # 기본적으로 NLB에서는 자동으로 redirect 지원을 하지 않기 때문에 아래와 같이 설정 진행 참고링크 확인
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: 'http'
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: 'https'
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'
    targetPorts:
      http: 8080
      # NLB 에서 TLS 종료를 진행하기 때문에 https -> http 변경
      https: http

  config: 
    allow-snippet-annotations: "true"
    compute-full-forwarded-for: "true"
    server-tokens: "false"
    use-forwarded-headers: "true"
    ssl-redirect: "false"
    use-proxy-protocol: "true"
    proxy-body-size: 300m
    http-snippet: |
      map true $pass_access_scheme {
        default "https";
      }
      map true $pass_port {
        default 443;
      }
      server {
        listen 8080 proxy_protocol;
        return 308 https://$host$request_uri;
      }
  metrics:
    enabled: true
  autoscaling:
    maxReplicas: 1
    minReplicas: 1
    enabled: true

