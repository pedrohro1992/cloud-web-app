resource "aws_launch_configuration" "this" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  key_name        = aws_key_pair.generated_key.key_name

  # Render the User Data script as template

  user_data = var.user_data

  #Required when using a launch configuration with an auto scaling group
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "this" {
  # Explicity depend on the launch of configuration's name so eatch time it's
  # Replaced, this ASG is also replaces
  name = var.cluster_name

  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = data.aws_subnets.public.ids
  target_group_arns    = [aws_lb_target_group.this.arn]
  health_check_type    = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  # Use the instance refresh to roll out chages to ASG
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags :
      key => upper(value)
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "this" {
  name     = "${var.cluster_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.this.id
}


