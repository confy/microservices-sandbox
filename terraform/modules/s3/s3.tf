data "archive_file" "build_handler" {
  type        = "zip"
  source_dir = "../build-handler"
  output_path = "./build-handler.zip"
}


resource "aws_s3_bucket" "build-handler" {
  bucket        = "${var.name}-build-handler-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_object" "build_handler_archive" {
  bucket = aws_s3_bucket.build-handler.id
  key    = "build-handler.zip"
  source = data.archive_file.build_handler.output_path
  etag   = filemd5(data.archive_file.build_handler.output_path)

  lifecycle {
    ignore_changes = [
      etag,
    ]
  }
}


data "archive_file" "commit_handler" {
  type        = "zip"
  source_dir = "../commit-handler"
  output_path = "./commit-handler.zip"
}


resource "aws_s3_bucket" "commit-handler" {
  bucket        = "${var.name}-commit-handler-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_object" "commit_handler_archive" {
  bucket = aws_s3_bucket.commit-handler.id
  key    = "commit-handler.zip"
  source = data.archive_file.commit_handler.output_path
  etag   = filemd5(data.archive_file.commit_handler.output_path)

  lifecycle {
    ignore_changes = [
      etag,
    ]
  }
}
