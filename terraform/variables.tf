#VPC variables

variable "aws_region" {
    description = "value for the aws_region"
    default = "us-east-1"
}

variable "vpc_name" {
    description = "value for the vpc_name"
    default = "eventstrat-vpc"
}

variable "vpc_cidr" {
    description = "value for the vpc_cidr"
    default = "10.0.0.0/16"
}

variable "azs" {
    description = "value for the availability zones"
    default = [ "us-east-1a","us-east-1b","us-east-1c" ]
}

variable "public_subnets" {
    description = "value for the public subnets"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
    description = "value for the public subnets"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

#EKS variables

variable "cluster_version" {
    description = "value for the kubernetes version"
    default = "1.30" 
}

variable "instance_types" {
    description = "value for the instance types"
    default = ["t3.medium"]
  
}