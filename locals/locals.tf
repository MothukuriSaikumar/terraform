locals {
  # Naming convention
  resource_name = "${var.project_name}-${var.environment}" # roboshop-dev
  instance_type = var.ec2_instance_type
    ami_id        = data.aws_ami.joindevops.id

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project_name}-${var.environment}-locals-demo"
      }
    )

}