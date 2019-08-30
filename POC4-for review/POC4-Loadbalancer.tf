# Creating ELB
resource "aws_elb" "LB" {
  name                  = "LB" 
  security_groups       = ["${aws_security_group.LB.id}"]
  subnets               = ["${aws_subnet.LB1.id}","${aws_subnet.LB2.id}"]
  internal              = false
 
 listener {
     instance_port       = 80
     instance_protocol   = "http"
     lb_port             = 80
     lb_protocol         = "http"
 }

 health_check {
     healthy_threshold   = 5
     unhealthy_threshold = 5
     timeout             = 5
     target              = "TCP:80"
     interval            = 20
 }
 tags = {
     name   = "LB"
 }
}
