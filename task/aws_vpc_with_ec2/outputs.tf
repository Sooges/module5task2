output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_id" {
  value = aws_instance.this.id
}
