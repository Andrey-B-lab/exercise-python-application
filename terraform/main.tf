provider "aws" {        # provider definition
  region = "us-east-1"  # the region I run the EC2 instance
}

// You need this if you use `data.aws_vpc.default.id`:
data "aws_vpc" "default" {
  default = true
}
