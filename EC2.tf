# Définition du groupe de sécurité EC2
resource "aws_security_group" "ec2_2" {
  name        = "${var.identifiant}_ec2_sg"
  description = "Allow SSH inbound traffic for EC2"
  vpc_id      = data.aws_vpc.selected.id #HTTP
  tags = {
 	Name = "${var.identifiant}_ec2_sg"
  }
}
resource "aws_security_group_rule" "http" {
  # Règle egress pour autoriser le trafic 
    type        = "egress" 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ec2_2.id
}

resource "aws_security_group_rule" "https" {
    type = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ec2_2.id
}

resource "aws_key_pair" "ec2_bastion" {
  key_name   = "ec2-key_wiwi"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD25CxiBL6W0ecX/3rGNHa4yGOkeYwonHym96EMo5woJe0Zs0cOjcfNPp0qVnywF92ZYglFGJRBFLC/82NY8V9OA5zQRX4TrflTfNbDD1uJRScr2BpBem4LVf6qD6ML6pgKjLl72eG4/sXSjqNDqkqm3k/yVWLDiQvtbqmg+yc+Bv6/+o2mv2x+35d6aBN9pEtrldQ9J/m2lqubHKe766Wq5DnwmoZMxIJ+PkPoiEXxcWExuU0LFSBCxtXkq6BeBum2gOOGV/jN68dbYXaFg32xb74SCSqfOeEHr5kViCbdlv3vBLZkVRmgnM3hJxShFtNRHG02dtPITeY5WTR2g5pz ec2-user@ip-10-0-1-91.eu-west-3.compute.internal"
}

 # Définition de l'instance EC2
 resource "aws_instance" "vm_2" {
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = data.aws_subnet.private-a.id
  availability_zone      = data.aws_availability_zones.available.names[0]
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_2.id]
  key_name = aws_key_pair.ec2_bastion.id

 tags = {
    Name        = upper("${var.identifiant}_VM2")
  }
}


