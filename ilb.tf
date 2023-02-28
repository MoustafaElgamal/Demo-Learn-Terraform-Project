resource "aws_lb" "internal-lb" {
  name               = "myapp-internal-lb"
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id = aws_subnet.private1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.private2.id
  }
}

resource "aws_lb_target_group_attachment" "internal-lb-tg-attachment" {
  target_group_arn = aws_lb_target_group.internal-lb-tg.arn
  target_id        = aws_lb.internal-lb.arn
  port             = 80
}

resource "aws_lb_target_group" "internal-lb-tg" {
  name        = "myapp-internal-lb-tg"
  #target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.myvpc.id
}
