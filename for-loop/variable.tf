variable "instance_name" {
  default = ["mongodb", "redis", "rabbitmq", "mysql"]

}
variable "ami_id" {
  default = "ami-09c813fb71547fc4f"

}
variable "zone_id" {
  default = "Z02608513S6JB1R040UCJ"

}
variable "domain_name" {
  default = "saikdevops.fun"

}