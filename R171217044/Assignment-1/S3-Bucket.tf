resource "aws_s3_bucket" "my-bucket" {
    bucket = "prajjawalmybucket"
    acl = "private"
    tags = {
      "Name" = "prajjawalmybucket"
    }
}