output "event_bus_arn" {
  value       = aws_cloudwatch_event_bus.ecommerce_bus.arn
  description = "ARN do Event Bus do EventBridge"
}

output "bus_name" {
  value       = aws_cloudwatch_event_bus.ecommerce_bus.name
  description = "Nome do Event Bus do EventBridge"
}