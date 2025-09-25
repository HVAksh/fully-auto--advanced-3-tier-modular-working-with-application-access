provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
resource "aws_wafv2_web_acl" "waf" {
  provider = aws.us-east-1
  name  = "devstudy-waf"
  scope = "CLOUDFRONT"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "devstudy-waf"
    sampled_requests_enabled   = true
    
  }
  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 200  # max requests from same IP in 5 mins
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "RateLimitRule"
    }
  }

  # Add rules optional hence not added
}
# provider "aws" {
#   alias  = "ap-south-1"
#   region = "ap-south-1"
# }
# Get the certificate from AWS ACM
# data "aws_acm_certificate" "issued" {
#   provider = aws.us-east-1
#   domain   = var.certificate_domain_name
#   statuses = ["ISSUED"]
#   most_recent = true
# }

#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled = true
  comment = "CloudFront distribution with WAF and ALB origin"
  aliases = [var.subject_alternative_names]

# ALB Origin 1 - Primary
  origin {
    domain_name = var.web_alb_dns_name # From active ALB
    origin_id   = "primary"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_read_timeout    = 60
      origin_keepalive_timeout = 60
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    
  }
# # ALB Origin 2 - Failover
#   origin {
#     domain_name = "dummy-dr.elb.amazonaws.com" # Replace this with real DR ALB DNS once DR region is deployed
#     origin_id   = "failover"
#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }
# # Origin Group for failover
#   origin_group {
#     origin_id = "alb-failover-group"

#     failover_criteria {
#       status_codes = [403, 404, 500, 502, 503, 504]
#     }

#     member {
#       origin_id = "primary" # ALB in ap-south-1
#     }

#     member {
#       origin_id = "failover" # ALB in ap-southeast-1
#     }
#   }

# Cache Behavior
  default_cache_behavior {
    
    target_origin_id       = "primary"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      headers      = []
      query_string = true
      
      cookies {
        forward = "all"
      }
    }
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = {
    Name = "cloudfront-waf"
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  
  }
  web_acl_id = aws_wafv2_web_acl.waf.arn
}
