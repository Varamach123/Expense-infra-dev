module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type          = "t3.micro"
  
  
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
  user_data = file("bastion.sh")

  tags = merge(
         var.common_tags,
         {
          Name = "${var.project_name}-${var.environment}-bastion"
         }

  )
  }
