# creating an s3 bucket 

resource "aws_s3_bucket" "state" {
  bucket = "blackntechbucket"

  # This will prevent our bucket from being deleted
  lifecycle {
    prevent_destroy = true
  }
}
