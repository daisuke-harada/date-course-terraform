variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_name" {
  type    = string
  default = "datecourses"
}

variable "region" {
  type    = string
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

variable "secrets" {
  type = object({
    db_name                      = string
    rails_master_key             = string
    db_username                  = string
    db_password                  = string
    react_app_google_map_api_key = string
    s3_name                      = string
  })
  default = {
    db_name                      = null
    rails_master_key             = null
    db_username                  = null
    db_password                  = null
    react_app_google_map_api_key = null
    s3_name                      = null
  }
}
