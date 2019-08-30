#CREATE EC2
#Public
resource "aws_instance" "Bastion" {
  ami                      = "${data.aws_ami.ubuntu.id}"
  instance_type            = "t2.micro"
  subnet_id                = "${aws_subnet.Bastion.id}"
  vpc_security_group_ids   = ["${aws_security_group.Bastion.id}"]
  key_name                 = "${aws_key_pair.KP2.id}"
  monitoring               = false
  tags = {
    Name                   = "Bastion"
  }
}

#WebHost
resource "aws_instance" "WH" {
  ami                      = "${data.aws_ami.ubuntu.id}"
  instance_type            = "t2.micro"
  subnet_id                = "${aws_subnet.WH1.id}"
  vpc_security_group_ids   = ["${aws_security_group.WH.id}"]
  key_name                 = "${aws_key_pair.KP2.id}"
  iam_instance_profile = "${aws_iam_instance_profile.EC2.name}"
  user_data                = "${file("POC4.sh")}"
  monitoring               = false
  tags = {
    Name                   = "WH"
  }
} 