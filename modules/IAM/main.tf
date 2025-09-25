##############################
# IAM Role for S3, EC2, Secret
##############################
resource "aws_iam_role" "ec2-s3-secret-role" {
  name = "ec2-s3-secret-role-${var.project_name}-${var.env}"

  # Terraform's "jsonencode" function converts a terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2-s3-secret-role.name # Associate the role with the instance profile
}
resource "aws_iam_policy_attachment" "ssm-core-attachment" {
  name       = "ssm-core-attachment"
  roles      = [aws_iam_role.ec2-s3-secret-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "s3-readonly-attachment" {
  name       = "s3-readonly-attachment"
  roles      = [aws_iam_role.ec2-s3-secret-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "ec2_secretsmanager_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ec2-s3-secret-role.name
}

##############################
# IAM Role for Backup
##############################
resource "aws_iam_role" "backup_role" {
  name = "aws-backup-role-${var.project_name}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      },
    ]
  })
}

# Attach managed policy for backups
resource "aws_iam_role_policy_attachment" "backup_service_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Attach managed policy for restores
resource "aws_iam_role_policy_attachment" "restore_service_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

##############################
# IAM Role for CloudTrail
##############################

resource "aws_iam_role" "cloudtrail_to_cw" {
  name = "cloudtrail-role-${var.project_name}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudtrail_policy" {
  name = "cloudtrail-policy-${var.project_name}-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail_policy_attach" {
  role       = aws_iam_role.cloudtrail_to_cw.name
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
}

##############################
# IAM Role for VPC Flow Logs
##############################

resource "aws_iam_role" "flow_logs_role" {
  name = "${var.project_name}-${var.env}-vpc-flow-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "${var.project_name}-${var.env}-flow-logs-policy"
  role = aws_iam_role.flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}
