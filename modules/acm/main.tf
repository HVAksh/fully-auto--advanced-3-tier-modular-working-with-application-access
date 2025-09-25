provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

# ACM Certificate Resource
resource "aws_acm_certificate" "cert" {
  provider          = aws.use1
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.devstudy.fun"
  ]

  tags = {
    Name = "CloudFront-Cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS Validation Records (CNAME)
resource "aws_route53_record" "cert_CNAME_reate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name   # <— CNAME name
      record = dvo.resource_record_value  # <— CNAME value
      type   = dvo.resource_record_type   # always "CNAME"
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}
# Validate the Certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  provider        = aws.use1
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_CNAME_reate_validation :
    record.fqdn
  ]
}
