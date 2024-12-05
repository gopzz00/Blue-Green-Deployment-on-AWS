variable "AWS_REGION" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
  type        = string
}

variable "INSTANCE_TYPE" {
  description = "Type of instance to use"
  type        = string 
}

variable "AWS_AMI_ID" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default      = "ami-0866a3c8686eaeeba"
}

variable "KEY_NAME" {
  description = "Key pair name for SSH access"
  type        = string
}
