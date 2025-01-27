resource "aws_sns_topic" "cliente_notificacao" {
  name = var.topic_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.cliente_notificacao.arn
}
