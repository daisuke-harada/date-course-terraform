resource "aws_ssm_parameter" "rails_master_key" {
  name  = "/backend/rails_master_key"
  type  = "SecureString"
  value = var.secrets["rails_master_key"]
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/backend/db_username"
  type  = "SecureString"
  value = var.secrets["db_username"]
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/backend/db_password"
  type  = "SecureString"
  value = var.secrets["db_password"]
}

resource "aws_ssm_parameter" "react_app_google_map_api_key" {
  name  = "/frontend/react_app_google_map_api_key"
  type  = "SecureString"
  value = var.secrets["react_app_google_map_api_key"]
}