variable "env" {
  type    = string
  default = "dev"
}

variable "table_name" {
  type = string
  default = "default-value"
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "myprofile" {
  default = "admin-user"
}


variable "bucket_name" {
  type    = string
  default = "in-god-we-trust-bucket"
}

variable "use_locals" {
  type    = bool
  default = true
}

