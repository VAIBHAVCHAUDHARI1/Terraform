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
resource "kubernetes_deployment" "wp" {
  metadata {
    name = "scalable-wp-example"
    labels = {
      App = "ScalablewpExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalablewpExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalablewpExample"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "example"
          env {
            name  = "WORDPRESS_DB_HOST"
            value = "dbexample" 
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = "root"
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "centos"
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = "unnati"
          }
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_deployment" "db" {
  metadata {
    name = "scalable-db-example"
    labels = {
      App = "ScalabledbExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalabledbExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalabledbExample"
        }
      }
      spec {
        container {
          image = "mysql:5.7"
          name  = "example"
        volume_mount {
                name    = "test"
                mount_path = "/data-store"
        }


          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "centos"
          }
          env {
            name  = "MYSQL_DATABASE"
            value = "unnati"
          }
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
  volume {
        name = "test"
        persistent_volume_claim {
          claim_name = "test-pvc"
        }
        }
}
      }
    }
  }

resource "kubernetes_service" "wp-service" {
  metadata {
    name = "wpxample"
  }
  spec {
    selector = {
      App = kubernetes_deployment.wp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
resource "kubernetes_service" "db-service" {
  metadata {
    name = "dbexample"
  }
  spec {
    selector = {
      App = kubernetes_deployment.db.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 3306
      target_port = 3306
    }

  }
}
