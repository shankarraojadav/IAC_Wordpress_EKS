
#
# Variables Configuration
#
variable "region" {
  default = "ap-south-1"
  type = string
}

variable "cluster-name" {
  default = "terraform-eks"
  type    = string
}


variable rds_credentials {
  type    = object({
    username = string
    password = string
    dbname = string
  })

  default = {
    username = "shankar"
    password = "shankar123"
    dbname = "mydb"
  }

  description = "Master DB username, password and dbname for RDS"
}


variable "ssh_key_name"{
  default = "jadhav"    //must be Present in AWS EC2 in Your Region
  type = string
}
