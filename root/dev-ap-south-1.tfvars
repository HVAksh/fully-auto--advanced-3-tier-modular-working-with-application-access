web_instance_type = "t2.nano"
app_instance_type = "t2.nano"

region       = "ap-south-1"
vpc_cidr     = "10.0.0.0/24"
env          = "dev"
project_name = "student"

pub_sub_1_cidr = "10.0.0.0/28"
pub_sub_2_cidr = "10.0.0.16/28"
web_sub_1_cidr = "10.0.0.32/28"
web_sub_2_cidr = "10.0.0.128/28"
app_sub_1_cidr = "10.0.0.144/28"
app_sub_2_cidr = "10.0.0.160/28"
db_sub_1_cidr  = "10.0.0.176/28"
db_sub_2_cidr  = "10.0.0.192/28"
domain_name = "devstudy.fun"
# certificate_domain_name = "devstudy.fun"
subject_alternative_name  = "www.devstudy.fun"

# cross_region_resource_arns = [
#   "arn:aws:backup:ap-south-1:123456789012:backup-vault/primary",
#   "arn:aws:backup:ap-southeast-1:123456789012:backup-vault/dr",
#   # "arn:aws:kms:ap-south-1:123456789012:key/<kms-key-id>"
# ]

web_desired_capacity = "2"
web_max_size         = "4"
web_min_size         = "1"

app_desired_capacity = "2"
app_max_size         = "4"
app_min_size         = "1"
alert_email          = "akshay.trainings@gmail.com"

