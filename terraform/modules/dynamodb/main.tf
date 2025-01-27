resource "aws_dynamodb_table" "inventario" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key
  range_key      = var.range_key
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.inventario.arn
}

output "dynamodb_table_stream_arn" {
  value = aws_dynamodb_table.inventario.stream_arn
}
