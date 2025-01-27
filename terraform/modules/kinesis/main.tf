resource "aws_kinesis_stream" "pedidos_stream" {
  name        = var.stream_name
  shard_count = var.shard_count
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.pedidos_stream.arn
}
