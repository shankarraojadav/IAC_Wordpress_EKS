resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
   db_name                            = var.rds_credentials.dbname
  username                        = var.rds_credentials.username
  password                        = var.rds_credentials.password
  parameter_group_name = "default.mysql5.7"
  identifier = "wordpress-db"
  skip_final_snapshot = true
  publicly_accessible = true
  #db_subnet_group_name = aws_db_subnet_group.default.id
 # vpc_security_group_ids = [aws_security_group.allow_rds.id]
  depends_on                      = [aws_security_group.allow_rds]
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.demo[*].id

  tags = {
    Name = "My DB subnet group"
  }
}
