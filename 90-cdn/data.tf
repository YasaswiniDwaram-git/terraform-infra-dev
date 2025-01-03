data "aws_cloudfront_cache_policy" "dynamic" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "static" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "https_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/https_certificate_arn"
}
