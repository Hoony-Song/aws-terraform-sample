resource "helm_release" "values_set" {
  count      = length(var.values_set) > 0 ? 1 : 0
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace = var.namespace
  version = var.chart_version
  create_namespace = true
  dependency_update = true
  dynamic "set" {
   for_each=var.values_set
   
   content{
     name=set.value["name"]
     value=set.value["value"]     
   }
 }  
}
resource "helm_release" "values_file" {
  count      = length(var.values_file) > 0 ? 1 : 0
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace = var.namespace
  version = var.chart_version 
  create_namespace = true
  dependency_update = true
  values = [
    templatefile(var.chart_Path,var.values_file)
  ]  
}
resource "helm_release" "values_empty" {
  count      =(length(var.values_file) ==0 && length(var.values_set)==0)?1:0
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace = var.namespace
  version = var.chart_version 
  create_namespace = true
  dependency_update = true
}

# resource "kubernetes_namespace" "example" {
#   count = var.namespace != "kube-system" ? 1 : 0
#   metadata {
#     name = var.namespace
#   }
# }