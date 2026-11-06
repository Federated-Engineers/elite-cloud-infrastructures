data "aws_vpc" "emr" {
  tags = {
    Name = "elite-emr-vpc"
  }
}