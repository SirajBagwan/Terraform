
variable "az-a" {
  default = "ap-south-1a"
}

variable "az-b" {
  default = "ap-south-1b"
}

variable "az-c" {
  default = "ap-south-1c"
}

variable "all_traffic_anywhere" {
  default = "0.0.0.0/0"
}
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "pub_sub_a" {
  default = "10.0.0.0/24"
}

variable "pub_sub_b" {
  default = "10.0.1.0/24"
}

variable "pri_sub_a" {
  default = "10.0.2.0/24"
}

variable "pri_sub_b" {
  default = "10.0.3.0/24"
}
