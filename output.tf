output "aws_ami" {
  value = data.aws_ami.ubuntu.id
}

output "RDS_instance_ip_addr" {
  value = aws_db_instance.wordpress_db.endpoint
}

output "Hostname" {
  value = kubernetes_service.ks_svc.status.0.load_balancer.0.ingress.0.hostname
}

