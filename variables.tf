variable "MY_IP" {}
variable "TERRAFORM_KEY" {}
variable "TERRAFORM_CREDENTIALS" {}


variable "vpc_cidr" {
  type    = string
  default = "10.123.0.0/16"

}

variable "main_instance_type" {
  type    = string
  default = "t2.micro"

}

variable "main_vol_size" {
  type    = number
  default = 8
}


variable "main_instance_count" {
  type    = number
  default = 1

}
