resource "aws_s3_bucket" "private" {
  bucket = "${var.app_name}-s3-bucket-daisuke"
  versioning {
    enabled = true # オブジェクトを変更・削除しても、いつでも以前のバージョンへ復元できるようになります。
  }
  server_side_encryption_configuration { # 暗号を有効化。 暗号化を有効にするとオブジェクト保存時に自動で暗号化し、オブジェクト参照時に自動で複合する。
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true # このバケットのパブリックACLをブロックするかどうか。
  block_public_policy     = true # このバケットのパブリックバケットポリシーをブロックするかどうか
  ignore_public_acls      = true # このバケットのパブリックACLを無視するかどうか。
  restrict_public_buckets = true # このバケットのパブリック バケット ポリシーを制限するかどうか
}