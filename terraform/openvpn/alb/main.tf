#alb
resource "aws_lb" "openvpn_alb" {
  name               = "openvpn-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.openvpn_alb_sg_id]
  subnets            = [var.openvpn_vpc_public_subnet_1_id, var.openvpn_vpc_public_subnet_2_id]

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-server"
    Module  = "alb"
  }
}

# Target Group
resource "aws_lb_target_group" "openvpn_alb_tg_943" {
  name        = "openvpn-alb-tg-943"
  port        = "943"
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.openvpn_vpc_id
}

resource "aws_lb_target_group" "openvpn_alb_tg_443" {
  name        = "openvpn-alb-tg-443"
  port        = "443"
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.openvpn_vpc_id
}

# Listener
resource "aws_lb_listener" "openvpn_alb_listener_943" {
  load_balancer_arn = aws_lb.openvpn_alb.arn
  port              = 943
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.openvpn_alb_tg_943.arn
  }
}

resource "aws_lb_listener" "openvpn_alb_listener_443" {
  load_balancer_arn = aws_lb.openvpn_alb.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.openvpn_alb_tg_443.arn
  }
}