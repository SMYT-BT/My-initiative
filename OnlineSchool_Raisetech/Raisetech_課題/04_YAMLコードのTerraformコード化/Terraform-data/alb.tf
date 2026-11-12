# -------------------------------------------------------------------
# Application Load Balancer
# -------------------------------------------------------------------
resource "aws_lb" "main" {
  name               = "My-ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  security_groups    = [aws_security_group.alb.id]

  tags = { Name = "MyALB" }
}

# -------------------------------------------------------------------
# Target Group
# -------------------------------------------------------------------
resource "aws_lb_target_group" "web" {
  name        = "My-Target-Group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = "/"
    port     = "traffic-port"
    interval = 10
    matcher  = "200"
  }

  tags = { Name = "ALB-Target-Group" }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 8080
}

# -------------------------------------------------------------------
# Listener
# -------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
