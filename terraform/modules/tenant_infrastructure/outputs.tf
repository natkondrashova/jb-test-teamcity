output "mysql_db" {
  value = {
    "address"  = aws_db_instance.tenant.address
    "username" = aws_db_instance.tenant.username
    "name"     = aws_db_instance.tenant.db_name
    "password" = aws_db_instance.tenant.password
  }
  sensitive = true
}

output "bucket" {
  value = aws_s3_bucket.tenant.bucket
}

output "bucket_acl" {
  value = aws_s3_bucket.tenant.acl
}

output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.tenant.arn
}


output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.tenant.id
}

output "cognito_client_pool" {
  value = aws_cognito_user_pool_client.tenant.id
}

output "aws_acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "aws_cognito_domain" {
  value = aws_cognito_user_pool_domain.tenant.domain
}

output "irsa_role_arns" {
  value = { for k, r in aws_iam_role.irsa_iam_role : k => r.arn }
}

output "dns_zone" {
  value = local.main_dns_zone
}

output "tenant_name" {
  value = var.tenant_name
}

output "temp_role" {
  value = aws_iam_role.temp_role.arn
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.filebeat.arn
}

output "cluster_name" {
  value = data.aws_eks_cluster.this.name
}