resource "kubernetes_service_account" "iamSA" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = { 
      "eks.amazonaws.com/role-arn" = "${var.role_arn}" }
    labels = {
      "app.kubernetes.io/managed-by" = "${var.labels_managed}"
    }
  }
}