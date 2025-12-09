variable "multiple_instances" {
  default = ["mongodb", "redis", "rabbitmq", "mysql"]
}

#route53 
variable "zone_id" {
  default = "Z02608513S6JB1R040UCJ"

}
variable "domain_name" {
  default = "saikdevops.fun"

}