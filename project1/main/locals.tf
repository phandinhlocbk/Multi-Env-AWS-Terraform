#----root/locals.tf----

locals {
  security_groups = {
    public = {
      name        = "test_public_sg"
      description = "Security for public subnet"
      ingress = {
        RDP = {
          from_port   = 3389
          to_port     = 3389
          protocol    = "TCP"
          cidr_blocks = [var.access_ip_myid]
        }

        http = {
          from_port   = 80
          to_port     = 80
          protocol    = "TCP"
          cidr_blocks = [var.access_ip_all]
        }
      }
    }

    private = {
      name        = "test_private_sg"
      description = "Security group for private subnet"
      ingress = {
        ssh = {
          from_port   = 22
          to_port     = 22
          protocol    = "TCP"
          cidr_blocks = [var.access_ip_bastion]
        }

        http = {
          from_port   = 80
          to_port     = 80
          protocol    = "TCP"
          cidr_blocks = [var.access_ip_alb]
        }

        https = {
          from_port   = 443
          to_port     = 443
          protocol    = "TCP"
          cidr_blocks = [var.access_ip_alb]
        }

      }
    }
  }
}