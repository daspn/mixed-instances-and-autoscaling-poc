resource "aws_launch_template" "lt" {
  name_prefix   = "lt-amazon-linux2"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  user_data = "${base64encode(data.template_file.user_data_tpl.rendered)}"
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 2
  max_size           = 20
  min_size           = 2

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.lt.id}"
        version = "$Latest"
      }
    }
    instances_distribution {
        on_demand_base_capacity = "1"
        on_demand_percentage_above_base_capacity = "0"
        spot_allocation_strategy = "capacity-optimized"
    }
  }
}

resource "aws_autoscaling_policy" "asg_autoscaling_policy" {
  name = "add-or-remove-based-on-cpu"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  estimated_instance_warmup = 30
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data_tpl" {
  template = "${file("cpu-spike.sh")}"
}