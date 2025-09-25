# global/route53/main.tf
resource "aws_route53_zone" "public_zone" {
  name = var.hosted_zone_name

}

# Failover records to CloudFront
resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "devstudy.fun"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name # Reference from waf-cloudfront, in case no TLS or NO Cloudfront use External LB details here
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "www_redirect" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "www.devstudy.fun"
  type    = "CNAME"
  ttl     = 300
  records = [ "devstudy.fun" ]
}
