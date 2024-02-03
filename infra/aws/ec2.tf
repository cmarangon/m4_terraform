// Key
resource "aws_key_pair" "ec2-key" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPkU4BJe6eGPpmUTtk/9WQ5mWlmnYpe7b3CkK9PvSQjI4qzL5zvRYhfdhaYmnCTcv5HSKx+0zSZCTT8pj10P28xsOcIp425rYdBJHKDG18SRLVj/TXjLBgsmXWWMWdPHeE08+WYd+i1N4/LLrE3qKiHG+n44rHyE/vIYFbVXktL2o1It+C5B4i0lwXplbxZLayLRMvWnuemN0WKBQYgT95lMt2CJd/WDOeUPTX8USkFYPBU3jEo38oFcZ5l/Bjw10fQRz9uePxfiVm/8Dwro04gL4eVY+ZoEt26U1lcHvX1HX4l2HVJAApeLWvcbM/o9pcOhBR5TIeriXYhdF3W7Xa+2uoU1YLiQARwWXUELjNhB734Dn6gCP8Kj7vwt23qUe1vtaDnF0dDGLjSx65SHZib9WEQoIlbqCApJeZ11mxjNFRBb1eFh8TIPNtJPpU2FIID7/V2KagcvlnAMHtfTWFZWVPe3/H4o5VzG/fuVwY8c5D18vEYKM9hnkN+9p7X/E= chicoguariba@Franciscos-MacBook-Pro.local"
}

// Launch Template
resource "aws_launch_template" "m4-ecs_lt" {
 name_prefix = "ecs-template"
 image_id = "ami-0277155c3f0ab2930"
 instance_type = "t3.micro"

 key_name = "ec2-key"
 vpc_security_group_ids = [aws_security_group.m4-security-group.id]
 iam_instance_profile {
   name = "ecsInstanceRole"
 }

 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp2"
   }
 }

 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "${var.prefix}-ecs-instance"
   }
 }

 user_data = filebase64("${path.module}/ecs.sh")
}

// Auto Scaling Group
resource "aws_autoscaling_group" "m4-ecs_asg" {
 vpc_zone_identifier = [aws_subnet.subnets[0].id]
 desired_capacity = 2
 max_size = 3
 min_size = 1

 launch_template {
   id = aws_launch_template.m4-ecs_lt.id
   version = "$Latest"
 }

 tag {
   key = "AmazonECSManaged"
   value = true
   propagate_at_launch = true
 }
}

// Application Load Balancer
resource "aws_lb" "m4-ecs_alb" {
 name = "ecs-alb"
 internal = false
 load_balancer_type = "application"
 security_groups = [aws_security_group.m4-security-group.id]
 subnets = aws_subnet.subnets[*].id

 tags = {
   Name = "${var.prefix}-ecs-alb"
 }
}

// Application Load Balancer Listener
resource "aws_lb_listener" "m4-ecs_alb_listener" {
 load_balancer_arn = aws_lb.m4-ecs_alb.arn
 port = 80
 protocol = "HTTP"

 default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.m4-ecs_tg.arn
 }
}

// Target Group
resource "aws_lb_target_group" "m4-ecs_tg" {
 name = "ecs-target-group"
 port = 80
 protocol = "HTTP"
 target_type = "ip"
 vpc_id = aws_vpc.m4-vpc.id

 health_check {
   path = "/"
 }
}