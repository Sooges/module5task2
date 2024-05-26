variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = ""
}
