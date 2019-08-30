#SECURITY GROUP

resource "aws_security_group" "Bastion" {
  name          = "Bastion"
  description   = "Allow SSH Admin"
  vpc_id        = "${aws_vpc.VPC-X.id}"
  ingress {
    from_port   = "${var.SSH}"
    to_port     = "${var.SSH}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ALLIP}"]
  }
  egress {
    from_port   = "${var.ALL}"
    to_port     = "${var.ALL}"
    protocol    = "-1"
    cidr_blocks = ["${var.ALLIP}"]
  }
  tags = {
    Name = "Bastion"
  }
}

resource "aws_security_group" "LB" {
  name            = "LB"
  description     = "Allow HTTP User"
  vpc_id          = "${aws_vpc.VPC-X.id}"
  ingress { 
    from_port   = "${var.HTTP}"
    to_port     = "${var.HTTP}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ALLIP}"]
  }
  egress {
    from_port   = "${var.ALL}"
    to_port     = "${var.ALL}"
    protocol    = "-1"
    cidr_blocks = ["${var.ALLIP}"]
  }
  tags = {
    Name = "LB"
  }
}


resource "aws_security_group" "WH" {
  name           = "WebHost"
  description    = "Allow SSH and HTTP"
  vpc_id         = "${aws_vpc.VPC-X.id}"
  ingress {
    from_port   = "${var.HTTP}"
    to_port     = "${var.HTTP}"
    protocol    = "tcp"
    security_groups = ["${aws_security_group.LB.id}"]
  }
 
  ingress {
    from_port   = "${var.SSH}"
    to_port     = "${var.SSH}"
    protocol    = "tcp"
    security_groups = ["${aws_security_group.Bastion.id}"]
  }
  egress {
    from_port   = "${var.ALL}"
    to_port     = "${var.ALL}"
    protocol    = "-1"
    cidr_blocks = ["${var.ALLIP}"]
  }
  tags = {
    Name = "WebHost"
  }
}
