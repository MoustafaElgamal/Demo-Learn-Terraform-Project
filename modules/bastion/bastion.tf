resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.all_ips_cidr]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.all_ips_cidr]
    prefix_list_ids = []
  }

   tags = {
    Name: "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent      = true
  owners           = [var.image_name_owner]

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami                     = data.aws_ami.latest-amazon-linux-image.id
  instance_type           = var.ec2_instance_type
  subnet_id = var.public1_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  availability_zone = var.region_subnet_1_id

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name


     tags = {
        Name: "bastion-host-server"
  }
}