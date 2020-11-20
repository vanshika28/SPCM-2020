resource "aws_s3_bucket" "my-bucket" {
    bucket = "abhinavs03"
    acl = "private"
    tags = {
      "Name" = "abhinavs03"
    }
}
