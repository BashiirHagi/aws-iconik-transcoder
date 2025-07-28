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
    "Version" : "2012-10-17",
    "Id" : "IconikAccessPolicy",
    "Statement" : [
      {
        "Sid" : "AllowObjectLevelAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::306744105408:user/bashiir_hagi"
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:RestoreObject"
        ],
        "Resource" : "arn:aws:s3:::iconik-ingest-bashiir/*"
      },
      {
        "Sid" : "AllowBucketLevelAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::306744105408:user/bashiir_hagi"
        },
        "Action" : [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetAccelerateConfiguration"
        ],
        "Resource" : "arn:aws:s3:::iconik-ingest-bashiir"
      }
    ]
  })
}