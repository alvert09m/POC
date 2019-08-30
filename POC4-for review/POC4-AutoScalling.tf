#Create image 
resource "aws_ami_from_instance" "WH-AS" {
  
  name                  = "WH-AS"
  source_instance_id    = "${aws_instance.WH.id}"
  
  tags                  = {
      name              = "WH-AS"
    }

}


#Launch config
resource "aws_launch_configuration" "WH-ASC" {
  
  name                   = "WH-ASC"
  image_id               = "${aws_ami_from_instance.WH-AS.id}"
  key_name               = "${aws_key_pair.KP2.id}"
  iam_instance_profile   = "${aws_iam_instance_profile.EC2.name}"
  instance_type          = "t2.micro"
  user_data              = "${file("POC4.sh")}"
  security_groups        = ["${aws_security_group.WH.id}"]
 
}
#Auto Scaling Group
resource "aws_autoscaling_group" "WH-ASG" {
  name                 = "WH-ASG"
  launch_configuration = "${aws_launch_configuration.WH-ASC.id}"
  health_check_grace_period = 60
  min_size             = 2
  max_size             = 2
  load_balancers       = ["${aws_elb.LB.id}"]
  lifecycle {
    create_before_destroy = true
  }
vpc_zone_identifier    = ["${aws_subnet.WH1.id}","${aws_subnet.WH2.id}"]
 tags = [
    {
      key                 = "Name"
      value               = "WH-ASG"
      propagate_at_launch = true
    }
    ]  
}
#Auto Scaling policies
resource "aws_autoscaling_policy" "ASG-Policy" {
  name                   = "ASG-Policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = "${aws_autoscaling_group.WH-ASG.id}"
  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }

  target_value = 80.0
}
}



