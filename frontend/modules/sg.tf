# SG to acces the ALB from the internet
resource "aws_security_group" "alb" {
  name   = "${var.cluster_name}-alb"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "alb" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = var.server_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_alb_connect_on_the_instance" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}
#SG to acces the ASG from the loadbalance
resource "aws_security_group" "instance" {
  name   = "${var.cluster_name}-instance"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "allow_connect_to_instance" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = var.server_protocol
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "allow_coonect_from_vpn" {
  description       = "Open access for the wireguard vpn"
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = data.aws_security_group.wireguard_vpn_sg.id
}

resource "aws_security_group_rule" "allow_http_on_instance" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port = var.server_port
  to_port   = var.server_port
  protocol  = var.server_protocol
  # Verificar o porque eu não consigo fazer conectar da internet para a instancia deixando apenas o ssource_security_group_id apontando
  # para o security_group do ALB
  cidr_blocks = local.all_ips

  # source_security_group_id = data.aws_security_group.this.id
}

resource "aws_security_group_rule" "allow_connect_to_internet" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

