variable "aws_region" {
  description = "The AWS region in which all resources will be created"
  type = string
}

variable "aws_account_id" {
  description = "The ID of the AWS Account in which to create resources."
  type = string
}

variable "vg_env" {
  description = "The environemnt (ex: dev, prod)"
  type = string
}

variable "vg_data_env" {
  description = "The data environment (ex: sandbox, live)"
  type = string
}

variable "node_count" {
  description = "The number of nodes in the refinery cluster"
  type = number
}

variable "instance_type" {
  description = "The instance type to be used for node creation (ex: m6.xlarge)"
  type = string
}

variable "ami" {
  description = "The AMI id to be used for node creation"
  type = string
}

variable "tags" {
  description = "The tags to be applied to all created resources"
  default = {}
  type = map
}

variable "refinery_version" {
  description = "The version of refinery to install"
  type = string
}

variable "vpc_cidr" {
  description = "The cidr block to be allocated to the cluster's vpc"
  type = string
}

variable "subnet_cidr" {
  description = "The cidr block to be allocated to the cluster's subnet"
  type = string
}

variable "refinery_config_file" {
  description = "The path to the refinery.toml file for refinery"
  type = string
}

variable "refinery_rules_file" {
  description = "The path to the rules.toml file for refinery"
  type = string
}
