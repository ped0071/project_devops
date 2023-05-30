provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s" {
  key_name   = "k8s-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCKe1wePcgxVbOZZTTgQOwcMZ9UBrTnruJbitpmCxlMA8B1b/DOzPPbdCALj+JH7ujyay+yuKnPiZ0qu+GsFdbbc924yVI1W13FzJmAovmQXvt53Gr5LKDFUuEAgihQPZL8rrScPF16iKxpy1rOeJZKSaPUoZr+QqXzst3s+ZxEcY7Raj3Xb8MNJS4eKvdXYzUuYJJfNNbsa1xw1CNGlw24166R0aX0/NGZICcLYbnxK+7lB0lRB7q4LqNcvsid/kl6grLIwlaRU1tYhE46ZkEThU9nX3dxNGhNQ6jGGsIE8yFDqjnln47kjIdMdsepQj4c1L7RpzkER7r+DvRMdkrp pedro@pedro"
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
  instance_type = "t3.medium"
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
