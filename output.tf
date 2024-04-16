output "RDS_instance_ip_addr" {
  value = aws_db_instance.default.endpoint
}

output "Hostname" {
  value = kubernetes_service.wpService.status.0.load_balancer.0.ingress.0.hostname
}

