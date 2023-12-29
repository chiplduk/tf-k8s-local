terraform {
    required_version = ">= 1.0.0"
    required_providers {
        kubernetes = {
        source  = "hashicorp/kubernetes"
        version = ">= 2.0.3"
        }
        helm = {
        source  = "hashicorp/helm"
        version = ">= 2.5.1"
        }
    }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }    
}