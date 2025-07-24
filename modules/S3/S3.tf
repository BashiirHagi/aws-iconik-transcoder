resource "aws_s3_bucket" "s3_iconik_master" {
  bucket = var.aws_s3_bucket
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "s3_iconik_master_versioning" {
  bucket = aws_s3_bucket.s3_iconik_master.id
  versioning_configuration {
    status = var.status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse_s3" {
  bucket = aws_s3_bucket.s3_iconik_master.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sencryption" {
  bucket = aws_s3_bucket.s3_iconik_master.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_policy" "allow_iconik_access" { //iconik-S3-bucket-access policy 
  bucket = aws_s3_bucket.s3_iconik_master.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::306744105408:user/iconik-access"  # IAM service account arn 
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.s3_iconik_master.arn,
          "${aws_s3_bucket.s3_iconik_master.arn}/*"
        ]
      }
    ]
  })
}
