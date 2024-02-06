#data "aws_security_group" "bastion" {
#  filter {
#    name   = "tag:Name"
#    values = ["SG_BASTION_EC2"]
#  }
#}

#resource "aws_security_group_rule" "allow_ec2_to_bastion" {
#  type                     = "ingress"
#  from_port                = 22
#  to_port                  = 22
#  protocol                 = "tcp"
#  source_security_group_id = data.aws_security_group.bastion.id
#  security_group_id        = aws_security_group.ec2.id
#}
