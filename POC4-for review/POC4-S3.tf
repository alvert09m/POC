resource "aws_s3_bucket" "vert0822" {
  bucket = "vert0827"
  acl    = "private"

  tags = {
    Name        = "vert0822"
    
  }
}