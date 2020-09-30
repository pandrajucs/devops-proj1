provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-03fce764d6d3fdd1f"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "server-1" {
    ami = "ami-00514a528eadbc95b"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "AWS_KeyPair"
    subnet_id = "subnet-034250c45e4a08fbf"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    user_data = "${file("script1.sh")}"
    tags = {
        Name = "Server-1"
    }
} 



resource "aws_instance" "server-2" {
   ami = "ami-00514a528eadbc95b"
   availability_zone = "us-east-1b"
   instance_type = "t2.micro"
   key_name = "AWS_KeyPair"
   subnet_id = "subnet-0d47b4ff30b766a68"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    user_data = "${file("script2.sh")}"
    tags = {
       Name = "Server-2"
   }
} 

resource "aws_instance" "server-3" {
   ami = "ami-00514a528eadbc95b"
   availability_zone = "us-east-1c"
   instance_type = "t2.micro"
   key_name = "AWS_KeyPair"
   subnet_id = "subnet-0e603ab3ebf20d410"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    user_data = "${file("script3.sh")}"
    tags = {
       Name = "Server-3"
   }
} 

resource "aws_lb_target_group" "tg" {
  name     = "AWS-NLB-TG"
  port     = 80
  protocol = "TCP"
  vpc_id   = "vpc-03fce764d6d3fdd1f"
}

resource "aws_lb" "nlb" {
  name               = "aws-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-034250c45e4a08fbf","subnet-0d47b4ff30b766a68","subnet-0e603ab3ebf20d410"]

} 

data "aws_route53_zone" "r53" {
  name = "pandrajucs.in"
}

