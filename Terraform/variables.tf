# Variables

variable "aws_access_key_id" {
    type        = string
    description = "AWS Access Key"
    sensitive   = true
}
variable "aws_secret_access_key" {
    type        = string
    description = "AWS Secret Key"
    sensitive   = true
}
variable "aws_session_token" {
    type        = string
    description = "AWS Session Token"
    sensitive   = true
}
variable "private_key_path" {
    type        = string
    description = "Private key path"
    sensitive   = true
}
variable "key_name" {
    type        = string
    description = "Private key path"
    sensitive   = false
}
variable "region" {
    type        = string
    description = "value for default region"
     default = "us-east-1"
}
# -------------------------end authentication-------------------------------

# for resouce

variable "enable_dns_hostnames" {
    type        = bool
    description = "Enable DNS hostnames in VPC"
    default     = true
}

variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
    default = "10.0.0.0/16"
}

variable "subnet_count"{
    type = number
    description = "number of subnets to create"
    default = 2
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "instance_count"{
    type = number
    description = "number of instances to create"
    default = 2
}

variable "project_name" {
    type = string
    description = "Name for common tags"
    default = "npa2022project"
}