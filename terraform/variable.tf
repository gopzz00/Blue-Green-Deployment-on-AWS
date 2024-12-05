variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string 
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  ami_id      = "ami-0866a3c8686eaeeba"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}
