provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s" {
  key_name   = "k8s-key"
  public_key = "sua-chave-ssh"
}

resource "aws_security_group" "k8s-sg" {
  name = "k8s-sg"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s-worker" {
  ami           = "ami-085925f297f89fce1"
  instance_type = "t"
  key_name      = "k8s-key"
  count         = 2
  tags = {
    Name = "k8s"
    type = "worker"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

resource "aws_instance" "k8s-master" {
  ami           = "ami-085925f297f89fce1"
  instance_type = "t3.medium"
  key_name      = "k8s-key"
  count         = 1
  tags = {
    Name = "k8s"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}
