provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  public_subnets  = [for az in var.azs : cidrsubnet("10.0.0.0/16", 8, index(var.azs, az))]

  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "this" {
  ami           = "i-026f2e650a66f4fb3"
  instance_type = var.instance_type
  subnet_id     = element(module.vpc.public_subnets, 0)

  tags = {
    Name = "MyInstance"
  }

  iam_instance_profile = length(aws_iam_instance_profile.this) > 0 ? aws_iam_instance_profile.t>
}

resource "aws_s3_bucket" "this" {
  count = var.s3_bucket_name != "" ? 1 : 0

  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "dev"
  }
}

resource "aws_iam_role" "this" {
  count = var.s3_bucket_name != "" ? 1 : 0

  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "s3-access-role"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.s3_bucket_name != "" ? 1 : 0

  role = aws_iam_role.this[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.this[0].arn,
          "${aws_s3_bucket.this[0].arn}/*"
        ]
      }
    ]
  })

resource "aws_iam_instance_profile" "this" {
  count = var.s3_bucket_name != "" ? 1 : 0

  name = "s3-access-instance-profile"
  role = aws_iam_role.this[0].name
}

