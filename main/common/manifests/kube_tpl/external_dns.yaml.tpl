apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${ACCOUNT_ID}:role/external-dns-irsa-role
  labels:
    app.kubernetes.io/name: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app.kubernetes.io/name: external-dns
  template:
    metadata:
      labels:
        app.kubernetes.io/name: external-dns
    spec:
      serviceAccountName: external-dns-irsa-role
      containers:
        - name: external-dns
          image: registry.k8s.io/external-dns/external-dns:v0.13.5
          args:
            - --source=service
            - --source=ingress
            - --domain-filter=${host_name}
            - --provider=aws
            - --policy=upsert-only
            - --aws-zone-type=public 
            - --registry=txt
            - --txt-owner-id=${host_zone}
          env:
            - name: AWS_DEFAULT_REGION
              value: ap-northeast-2 