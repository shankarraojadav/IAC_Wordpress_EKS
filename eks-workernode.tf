resource "aws_iam_role" "node_iam" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_iam.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_iam.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_iam.name
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.terra_eks.name
  node_group_name = "example"
  node_role_arn   = aws_iam_role.node_iam.arn
  subnet_ids      = [aws_subnet.public.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id = aws_launch_template.custom_ubuntu.id
    version = "$Latest"
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_launch_template" "custom_ubuntu" {
  name_prefix   = "custom-ubuntu-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"  # Adjust instance type as needed
  key_name      = var.ssh_key_name  # Use your SSH key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_server.id]
  }

  tag_specifications {
    resource_type = "instance"  # Removed backticks from here
    tags = {
      Name = "Custom Ubuntu Node"
    }
  }
}

