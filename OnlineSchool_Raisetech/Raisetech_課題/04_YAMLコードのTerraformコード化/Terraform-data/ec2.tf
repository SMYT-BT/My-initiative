# -------------------------------------------------------------------
# EC2
# -------------------------------------------------------------------
resource "aws_instance" "web" {
  ami                                  = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type                        = "t2.micro"
  subnet_id                            = aws_subnet.public_a.id
  vpc_security_group_ids               = [aws_security_group.ec2.id]
  key_name                             = var.ec2_key_name
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  monitoring                           = false

  tags = { Name = "WebServer-EC2" }
}
