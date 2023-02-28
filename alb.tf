resource "aws_security_group" "alb-sg" {
  name        = "myapp-alb-sg"
  vpc_id      = aws_vpc.myvpc.id

# Inbound Rules
# HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from my IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "myapp-alb" {
  name               = "myapp-alb-tf"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb-sg.id}"]
  subnets            = ["${aws_subnet.private1.id}","${aws_subnet.private2.id}"]

  tags = {
    Environment = var.env_prefix
  }
}

resource "aws_lb_target_group_attachment" "alb-tg-attachment" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_lb.myapp-alb.arn
  port             = 80
}

resource "aws_lb_target_group" "alb-tg" {
  name        = "myapp-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.myvpc.id

  stickiness {
    type = "lb_cookie"
   }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/login"
    port = 80
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_lb.myapp-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb-tg.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = "${aws_lb.myapp-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::748938456886:user/terraform"
  default_action {
    target_group_arn = "${aws_lb_target_group.alb-tg.arn}"
    type             = "forward"
  }
}