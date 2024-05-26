module "aws_vpc_with_ec2" {
  source         = "./aws_vpc_with_ec2"
  azs            = ["eu-naorth-1"]
  instance_type  = "t3.micro"                        
  s3_bucket_name = "s3_bucket_name"          
}

output "vpc_id" {
  value = module.aws_vpc_with_ec2.vpc_id
}

output "instance_id" {
  value = module.aws_vpc_with_ec2.instance_id
}

