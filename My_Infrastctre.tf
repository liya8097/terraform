provider "aws" {
  access_key = "AKIA44GRPZWZKIKXSNOO"
  secret_key = "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"
  region     = "us-east-2"
}
resource "aws_s3_bucket" "b" {
  bucket = "my-first-tf-bucket"

}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysecuritygroup.id]
  subnets            = aws_subnet.main.*.id

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.b.bucket
    prefix  = "test-lb"
    enabled = true
  }
}
resource "aws_instance" "my_webserver" {
  ami                    = "ami-0d8d212151031f51c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysecuritygroup.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip= 'curl http://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>Hello from server 1 with IP: $myip</h2>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
}
resource "aws_instance" "myelse_webserver" {
  ami                    = "ami-0d8d212151031f51c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysecuritygroup.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip= 'curl http://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>Hello from server 2 with IP: $myip</h2>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
}
resource "aws_security_group" "mysecuritygroup" {
  name        = "WebServer Security Group"
  description = "My first security group"


  ingress {
    from_port   = 80
    to_port     = 80
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
