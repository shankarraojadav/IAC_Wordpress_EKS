provider "aws" {

}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
