resource "aws_lb" "app" {
  load_balancer_type = "application"
  name               = "{{appName}}-alb"
}
