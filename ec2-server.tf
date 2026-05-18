# Region

# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-automate-key-josh-new"
  public_key = file(pathexpand("~/.ssh/terra-automate-key-josh-new.pub"))
}

# Default VPC
resource "aws_default_vpc" "default" {
}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "terra-security-group-new"
  vpc_id      = aws_default_vpc.default.id
  description = "Inbound and outbound rules for instance security group"
}

# Ingress Rules

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Egress Rule

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instances

resource "aws_instance" "my_instance" {
  count         = 1
  ami           = "ami-07a00cf47dbbc844c"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.my_key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "terra-automate-server-${count.index}"
  }
}

# Instance State (Fixed for multiple instances)

resource "aws_ec2_instance_state" "my_instance_state" {
  count       = 1
  instance_id = aws_instance.my_instance[count.index].id
  state       = "stopped"
}
