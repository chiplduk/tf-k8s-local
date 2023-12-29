resource "kubernetes_namespace" "argocd" {  
  metadata {
    name = "argocd"
    labels = {
       "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name" = "argocd"
      "meta.helm.sh/release-namespace" = "argocd"
    }
  }
}

resource "kubernetes_namespace" "applications" {  
  metadata {
    name = "applications"
    labels = {
       "app.kubernetes.io/managed-by" = "Helm"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata.0.name
  version          = "5.51.6"

  depends_on = [
    kubernetes_namespace.argocd
  ]  
}

resource "kubernetes_ingress_v1" "argocd-ingress" {
  metadata {
    name = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd.metadata.0.name
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
    }
  }
  
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "argocd.svc.cluster.local"
      http {
        path {
          backend {
            service {
              name = "argocd-server"
              port {
                name = "https"
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}

#https://artifacthub.io/packages/helm/argo/argocd-apps
resource "helm_release" "argocd-apps" {
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  namespace        = kubernetes_namespace.argocd.metadata.0.name
  version          = "1.4.1"

  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.argocd
  ]

  values = [
    file("applications.yaml")
  ]
}