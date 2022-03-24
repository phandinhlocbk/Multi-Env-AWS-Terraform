#------loadbalancing/main.tf-----

resource "aws_lb" "test_lb" {
  name               = "test-loadbalancer"
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = var.public_subnets
  idle_timeout = 400

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test_tg" {
  name     = "test_lb_tg_-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "test_lb_listener" {
  load_balancer_arn = aws_lb.test_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}