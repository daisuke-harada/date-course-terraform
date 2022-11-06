variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_name" {
  type    = string
  default = "datecourse"
}

variable "region" {
  type = string
  default = "ap-northeast-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "az_count" {
  type    = string
  default = "2"
}

variable "base_domain" {
  type    = string
  default = "datecourses.com"
}