resource "aws_route53_record" "roboshop" {
  count   = 4
  zone_id = var.zone_id
  name    = "${var.multiple_instances[count.index]}.${var.domain_name}" #mongodb.saikdevops.fun
  
  type    = "A"
  ttl     = 1
  records = [aws_instance.terraform[count.index].private_ip] # private_ip of ec2 instances
  allow_overwrite = true
}