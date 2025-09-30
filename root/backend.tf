terraform {
  backend "s3" {
    bucket = "terraform-slbkt"
    key    = "tfstate/statefile.tfstate"
    region = "ap-south-1"
  }
}

# Require changes for variable