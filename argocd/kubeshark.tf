# resource "kubernetes_namespace" "kubeshark" {  
#   metadata {
#     name = "kubeshark"
#     labels = {
#        "app.kubernetes.io/managed-by" = "Helm"
#     }
#   }
# }

# resource "helm_release" "kubeshark" {
#   name             = "kubeshark"
#   repository       = "https://helm.kubeshark.co"
#   chart            = "kubeshark"
#   namespace        = kubernetes_namespace.kubeshark.metadata.0.name
#   version          = "v51.0.38"

#   depends_on = [
#     kubernetes_namespace.kubeshark
#   ]  
# }

# resource "kubernetes_ingress_v1" "kubeshark-ingress" {
#   depends_on = [
#     helm_release.kubeshark
#   ]  

#   metadata {
#     name = "kubeshark-server-ingress"
#     namespace = kubernetes_namespace.kubeshark.metadata.0.name
#   }
  
#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       host = "ks.svc.cluster.local"
#       http {
#         path {
#           backend {
#             service {
#               name = "kubeshark-front"
#               port {
#                 number = "80"
#               }
#             }
#           }
#           path = "/"
#         }
#       }
#     }
#   }
# }