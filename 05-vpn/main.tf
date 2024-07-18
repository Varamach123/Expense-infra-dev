resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  # you can paste the public key directly like this
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQ/3Tsqs4OEfKezNOBVnF0hlatVP+cfKdZQcbZMGxI6 SRIKAR@DESKTOP-4IP4CAE"
  #public_key = file("~/.ssh/openvpn.pub")
  # ~ means windows home directory
}



module "vpc" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-vpc"

  instance_type          = "t3.micro"
  key_name = resource.aws_key_pair.vpn.key_name
  
  vpc_security_group_ids = [data.aws_ssm_parameter.vpc_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
 

  tags = merge(
         var.common_tags,
         {
          Name = "${var.project_name}-${var.environment}-vpc"
         }

  )
  }
