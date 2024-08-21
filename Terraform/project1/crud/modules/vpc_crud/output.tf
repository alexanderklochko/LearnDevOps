output "vpc_id" {
  value = aws_vpc.vpc.id
}

/* output "public_subnets_id" {
  value = [for env in aws_subnet.public: env.id]
} */

output "private_subnets_id" {
  value = [for env in aws_subnet.private: env.id]
}

output "public_subnets_id" {
  value = local.public_subnet_id
}

output "private_subnets_RDS_id" {
  value = [for env in aws_subnet.private_rds: env.id ]
} 
