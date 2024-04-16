resource "kubernetes_deployment" "ks_dep" {
  metadata {
    name = "ks-dep"
    labels = {
      App = "wordpress"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        pod = "wordapp"
      }
    }

    template {
      metadata {
        labels = {
         pod = "wordapp"
        }
      }

      spec {
        container {
          image = "wordpress:latest"
          name  = "wordapp"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = aws_db_instance.wordpress_db.endpoint
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = aws_db_instance.wordpress_db.username
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = aws_db_instance.wordpress_db.password
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = aws_db_instance.wordpress_db.db_name
          }
          env {
            name  = "WORDPRESS_TABLE_PREFIX"
            value = "wp_"
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

resource "kubernetes_service" "ks_svc" {
  metadata {
    name = "terraform-example"
  }


  depends_on = [
    kubernetes_deployment.ks_dep
  ]

  spec {
    selector = {
       app = kubernetes_deployment.ks_dep.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

