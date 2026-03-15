variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "workshop"
  }
}

variable "assume_role" {
  type = object({
    arn    = string
    region = string
  })

  default = {
    arn    = "arn:aws:iam::196338543880:role/evandromelos-role"
    region = "us-east-1"
  }
}


variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    public_route_table_name  = string
    private_route_table_name = string
    nat_gateway              = string

    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))

    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    name                     = "workshop-devops-vpc"
    cidr_block               = "10.0.0.0/24"
    public_route_table_name  = "workshop-devops-public-rt"
    private_route_table_name = "workshop-devops-private-rt"
    nat_gateway              = "workshop-devops-nat-gateway"

    public_subnets = [
      {
        name                    = "public-subnet-us-east-1a"
        cidr_block              = "10.0.0.0/26"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = true
      },
      {
        name                    = "public-subnet-us-east-1b"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
      }
    ]

    private_subnets = [
      {
        name                    = "private-subnet-us-east-1a"
        cidr_block              = "10.0.0.128/26"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = false
      },
      {
        name                    = "private-subnet-us-east-1b"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
      }
    ]
  }
}

variable "igw" {
  type = object({
    name = string
  })

  default = {
    name = "workshop-devops-igw"
  }
}

