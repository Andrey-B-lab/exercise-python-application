resource "aws_security_group" "my_ip_ssh" {
  name        = "sg-my-ip-ssh"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "sg-my-ip-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "my_ip_ssh_ingress" {
  security_group_id = aws_security_group.my_ip_ssh.id
  description       = "SSH from my IP"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
}

resource "aws_vpc_security_group_egress_rule" "my_ip_ssh_egress" {
  security_group_id = aws_security_group.my_ip_ssh.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "jenkins_access" {
  name        = "sg-jenkins-access"
  description = "Allow SSH from Jenkins IP"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "sg-jenkins-access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_access_ingress" {
  security_group_id = aws_security_group.jenkins_access.id
  description       = "SSH from Jenkins server"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.jenkins_ip_address}/32"]
}

resource "aws_vpc_security_group_egress_rule" "jenkins_access_egress" {
  security_group_id = aws_security_group.jenkins_access.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "https_world" {
  name        = "sg-https-world"
  description = "Allow HTTPS from anyone"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "sg-https-world"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https_world_ingress" {
  security_group_id = aws_security_group.https_world.id
  description       = "HTTPS from anywhere"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_vpc_security_group_egress_rule" "https_world_egress" {
  security_group_id = aws_security_group.https_world.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
