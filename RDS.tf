variable "identifiant" {
	description = "Votre ID"
	default = "wiwienvoiture"
}

resource "aws_security_group" "rds_5432" {
  name        = "rds_5432"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "allow_5432"
  }
}

resource "aws_security_group_rule" "allow_ec2_to_bastion" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.rds_5432.id
}

# Règle egress, RDS initie les connexion sortante
#egress {
#    from_port   = 0 #tous les ports
#    to_port     = 0
#    protocol    = "-1" #tous les protocoles
#    cidr_blocks = ["0.0.0.0/0"] #s'applique à toutes les addresses IP
#  }

resource "aws_db_subnet_group" "database" {
  name       = "database.group"
  subnet_ids = [data.aws_subnet.private-a.id, data.aws_subnet.private-b.id]

  tags = {
    Name = "Groupe de sous réseaux de wiwienvoiture"
  }
}



resource "aws_db_instance" "wiwienvoiture" {
  identifier	       = "wiwienvoiture"
  availability_zone      = "eu-west-3a"
  license_model        = "postgresql-license"
  port		       = 5432
  allocated_storage    = 10
  db_name              = "voiture"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "passworstoto"
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_5432.id]
  db_subnet_group_name   = aws_db_subnet_group.database.name
}

