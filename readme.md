Architecture Overview
Architecture Diagram

1. VPC (12 Subnets, 10 Route Tables, 1 IGW, 3 NAT)
2. Security Group
3. EC2
4. Auto Scaling Group (ASG with IAM & Launch Template)
5. ALB (2 Target Groups)
6. IAM (for Image Build & Access Control)
7. RDS (MySQL)
8. Secrets Manager
9. S3 (Data + VPC Flow Logs)
10. Cloud Watch
11. SNS
12. Cloud Trail
13. Cloud Front
14. ACM (SSL Certificates)
15. WAF 
16. Route 53

