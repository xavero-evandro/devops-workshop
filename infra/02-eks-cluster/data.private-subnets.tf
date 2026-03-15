data "aws_subnets" "private" {
  filter {
    name   = "tag:Project"
    values = ["workshop"]
  }

  filter {
    name   = "tag:Name"
    values = ["private-subnet-*"]
  }
}
