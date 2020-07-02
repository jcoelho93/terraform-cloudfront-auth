module "cloudfront_auth" {
  source = "../"

  auth_vendor             = "cognito"
  cloudfront_distribution = "private.example.com"
  client_id               = "CHANGE_ME"
  client_secret           = "CHANGE_ME"
  base_uri                = "https://auth-xxxxxx.auth.us-east-1.amazoncognito.com"
  redirect_uri            = "https://private.example.com/callback"
  github_organization     = "exampleorg"

  bucket_name                    = "private.example.com"
  region                         = "eu-west-1"
  cloudfront_acm_certificate_arn = aws_acm_certificate.cert.arn
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = "example.com"
  validation_method = "EMAIL"
  subject_alternative_names = [
    "*.example.com"
  ]
}

// A test object for the bucket.
resource "aws_s3_bucket_object" "test_object" {
  bucket       = module.cloudfront_auth.s3_bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = sha256(file("${path.module}/index.html"))
}
