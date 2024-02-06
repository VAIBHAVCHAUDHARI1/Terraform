terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}
resource "kubernetes_persistent_volume_claim" "example" {
  metadata {
        name = "test-pvc"
  }
  spec {
        storage_class_name = "standard-rwo"
        access_modes = ["ReadWriteOnce"]
        resources {
        requests = {
        storage = "5Gi"
        }
        }
  }
}
resource "kubernetes_persistent_volume_claim" "example" {
  metadata {
        name = "test-pvc"
  }
  spec {
        storage_class_name = "standard-rwo"
        access_modes = ["ReadWriteOnce"]
        resources {
        requests = {
        storage = "5Gi"
        }
        }
  }
}
