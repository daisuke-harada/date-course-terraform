variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "app_name" {
  type = string
  default = "date_course"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}