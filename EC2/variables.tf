variable "az" {
  default = "ap-south-1a"
}

variable "aws_ami_id" {
  default = "ami-0a7cf821b91bcccbc"
}

variable "access_key" {
  default = "newkey"
}

variable "secondary_ip" {
  default = "10.0.0.7"
}

variable "Instance_Type" {
  default = "t2.micro"
}

variable "Count" {
  default = 1
}

variable "subnetId"{
  default = "Update id of subnet from UI"
}

variable "SGroup"{
  default = "Update id of SG from UI"
}

variable "RTD_Size"{
  default = 50
}
