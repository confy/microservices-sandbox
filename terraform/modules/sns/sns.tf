resource "aws_sns_topic" "commits" {
    name = "${var.name}-commits-topic"
}