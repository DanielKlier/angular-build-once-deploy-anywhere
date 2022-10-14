variable "origin_bucket_name" {
  type = string
}

variable "origin_path" {
  type = string
}

variable "default_root_object" {
  type = string
  default = "/index.html"
}
