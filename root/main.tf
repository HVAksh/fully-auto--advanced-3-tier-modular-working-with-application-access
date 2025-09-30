module "network" {
  source = "../modules/network"

  region         = var.region
  vpc_cidr       = var.vpc_cidr
  pub_sub_1_cidr = var.pub_sub_1_cidr
  pub_sub_2_cidr = var.pub_sub_2_cidr
  web_sub_1_cidr = var.web_sub_1_cidr
  web_sub_2_cidr = var.web_sub_2_cidr
  app_sub_1_cidr = var.app_sub_1_cidr
  app_sub_2_cidr = var.app_sub_2_cidr
  db_sub_1_cidr  = var.db_sub_1_cidr
  db_sub_2_cidr  = var.db_sub_2_cidr
  nat_gw_1_id    = module.nat.nat-gw-1_id
  nat_gw_2_id    = module.nat.nat-gw-2_id
  env            = var.env

}

module "security_group" {
  source = "../modules/security_group"

  vpc_id = module.network.vpc_id
}

module "nat" {
  source = "../modules/nat"

  pub_sub_1_id = module.network.pub_sub_1_id
  pub_sub_2_id = module.network.pub_sub_2_id
  igw_id       = module.network.igw_id

}

module "alb" {
  source = "../modules/alb"

  project_name            = var.project_name
  region                  = var.region
  vpc_id                  = module.network.vpc_id
  env                     = var.env
  app_alb_sg_id           = module.security_group.app_sg_id
  web_alb_sg_id           = module.security_group.web_alb_sg_id
  pub_sub_1_id            = module.network.pub_sub_1_id
  pub_sub_2_id            = module.network.app_sub_2_id
  web_sub_1_id            = module.network.web_sub_1_id
  web_sub_2_id            = module.network.web_sub_2_id
  

}

module "asg" {
  source               = "../modules/asg"
  environment          = var.env
  project_name         = var.project_name
  env                  = var.env
  web_instance_type    = var.web_instance_type
  web_sg_id            = module.security_group.web_sg_id
  web_sub_1_id         = module.network.web_sub_1_id
  web_sub_2_id         = module.network.web_sub_2_id
  app_instance_type    = var.app_instance_type
  app_sg_id            = module.security_group.app_sg_id
  app_sub_1_id         = module.network.app_sub_1_id
  app_sub_2_id         = module.network.app_sub_2_id
  app_alb_tg_arn       = module.alb.app_tg_arn
  web_alb_tg_arn       = module.alb.web_tg_arn
  ec2_profile_name     = module.IAM.ec2_profile_name
  ec2_profile_arn      = module.IAM.ec2_profile_arn
  app_alb_dns_name     = module.alb.app_alb_dns_name
  web_alb_dns_name     = module.alb.web_alb_dns_name
  web_desired_capacity = var.web_desired_capacity
  web_max_size         = var.web_max_size
  web_min_size         = var.web_min_size
  app_desired_capacity = var.app_desired_capacity
  app_max_size         = var.app_max_size
  app_min_size         = var.app_min_size
  db_host              = module.db-rds.aurora_cluster_endpoint
  db_name              = module.db-rds.aurora_database_name
  db_password          = module.secret-manager.db_password
  db_user              = module.secret-manager.db_username
  web_tier_sns_arn     = module.sns.web_tier_sns_arn
  app_tier_sns_arn     = module.sns.app_tier_sns_arn
  depends_on = [
    module.db-rds,
    module.secret-manager,
    module.alb,
    module.IAM
  ]

}

module "backup" {
  source          = "../modules/backup"
  backup_role_arn = module.IAM.backup_role_arn

}

module "secret-manager" {
  source = "../modules/secret-manager"

  project_name = var.project_name

}

module "db-rds" {
  source      = "../modules/db-rds"
  db_sub_1_id = module.network.db_sub_1_id
  db_sub_2_id = module.network.db_sub_2_id
  db_sg_id    = module.security_group.db_sg_id
  db_password = module.secret-manager.db_password
  depends_on = [ 
    module.secret-manager,
    module.network ]
}


module "IAM" {
  source       = "../modules/IAM"
  project_name = var.project_name
  env          = var.env

}

module "acm" {
  source = "../modules/acm"

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_name
  hosted_zone_id = module.route53.public_zone_id

}

module "route53" {
  source = "../modules/route53"

  cloudfront_domain_name    = module.waf-cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.waf-cloudfront.cloudfront_hosted_zone_id
}

module "waf-cloudfront" {
  source = "../modules/waf-cloudfront"

  subject_alternative_names   = var.subject_alternative_name
  web_alb_dns_name    = module.alb.web_alb_dns_name
  certificate_arn         = module.acm.certificate_arn

}

module "monitoring" {
  source = "../modules/monitoring"

  vpc_id                    = module.network.vpc_id
  env                       = var.env
  project_name              = var.project_name
  flow_logs_role_arn        = module.IAM.flow_logs_role_arn
  cloudtrail_to_cw_role_arn = module.IAM.cloudtrail_to_cw_role_arn

depends_on = [ 
  module.network,
  module.IAM ]
}

module "sns" {
  source = "../modules/sns"

  env          = var.env
  project_name = var.project_name
  alert_email  = var.alert_email

}
