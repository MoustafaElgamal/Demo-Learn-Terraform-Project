data "aws_ami" "amazon-ami-linux" {
  most_recent = true
  owners      = [var.image_name_owner]

  filter {
    name   = "name"
    values = [var.image_name]
  }
}

/*resource "aws_autoscaling_attachment" "asg_alb" {
  autoscaling_group_name = aws_autoscaling_group.myapp-frontend-asg.id
  lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}*/

resource "aws_launch_configuration" "myapp-frontend-lunch-config" {
  name          = "myapp-frontend-lunch-config"
  image_id      =  "${data.aws_ami.amazon-ami-linux.id}"
  instance_type = var.ec2_instance_type
}

resource "aws_autoscaling_group" "myapp-frontend-asg" {
  name                      = "myapp-frontend-asg"
  depends_on = [aws_launch_configuration.myapp-frontend-lunch-config]
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.myapp-frontend-lunch-config.id
  vpc_zone_identifier       = [var.private1_subnet_id, var.private2_subnet_id]
  target_group_arns = [aws_lb_target_group.alb-tg.arn]
}


/*resource "aws_autoscaling_attachment" "asg_internal-lb" {
  autoscaling_group_name = aws_autoscaling_group.myapp-backend-asg.id
  elb                    = aws_lb.internal-lb.id
}*/

resource "aws_launch_configuration" "myapp-backend-lunch-config" {
  name          = "myapp-backend-lunch-config"
  image_id      =  "${data.aws_ami.amazon-ami-linux.id}"
  instance_type = var.ec2_instance_type
}

resource "aws_autoscaling_group" "myapp-backend-asg" {
  name                      = "myapp-backend-asg"
  depends_on = [aws_launch_configuration.myapp-backend-lunch-config]
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.myapp-backend-lunch-config.id
  vpc_zone_identifier       = [var.private1_subnet_id, var.private2_subnet_id]
  target_group_arns = [aws_lb_target_group.internal-lb-tg.arn]
}