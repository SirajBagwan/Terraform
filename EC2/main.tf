# Creaing secodary network interface (ENI) for instance
resource "aws_network_interface" "Eni" {
  subnet_id   = var.subnetId
  private_ips = [var.secondary_ip]
}

# Attaching the ENI with EC2 as Secondary IP
resource "aws_network_interface_attachment" "test" {
  instance_id          = aws_instance.web.id
  network_interface_id = aws_network_interface.Eni.id
  device_index         = 1
  depends_on           = [aws_instance.web, aws_network_interface.Eni]
}

# Launching an EC2 instances
resource "aws_instance" "web" {
  count                       = var.Count
  ami                         = var.aws_ami_id
  instance_type               = var.Instance_Type
  associate_public_ip_address = true
  availability_zone           = var.az
  subnet_id                   = var.subnetId
  vpc_security_group_ids      = var.SGroup
  key_name                    = var.access_key
  user_data                   = <<-EOF
                                  #!/bin/bash
                                  apt update -y
                                  EOF
  root_block_device {
    volume_size           = var.RTD_Size
    delete_on_termination = false
  }
  tags = {
    Name = "Web_Server"
  }
}
