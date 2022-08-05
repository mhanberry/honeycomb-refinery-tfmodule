# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Provider version 2.X series is the latest, but has breaking changes with 1.X series.
  version = "4.21.0"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [
    var.aws_account_id
  ]
  
  # Default tags for deployed resources
  default_tags {
    tags = {
      "vg:env" = var.vg_env
      "vg:data_env" = var.vg_data_env
      Name = "honeycomb-refinery"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE REMOTE STATE STORAGE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # Only allow this Terraform version. Note that if you upgrade to a newer version, Terraform won't allow you to use an
  # older version, so when you upgrade, you should upgrade everyone on your team and your CI servers all at once.
  required_version = "= 0.12.31"
}
