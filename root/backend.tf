terraform {
  backend "s3" {
    bucket = "multi-region-s3-bukt"
    key    = "backend/3tier-MR.tfstate"
    region = "ap-south-1"
  }
}

# Require changes for variable