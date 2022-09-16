# outputs for sns topic arn and name
output "commits_topic_arn" {
    value = aws_sns_topic.commits.arn
}

output "commits_topic_name" {
    value = aws_sns_topic.commits.name
}
