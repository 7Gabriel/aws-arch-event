variable "bus_name" {
  type        = string
  description = "EcommerceEventBus"
}

variable "target_arn" {
  description = "ARN do destino para os eventos do EventBridge"
  type        = string
}

variable "lambda_execution_role_name" {
  description = "Nome da IAM Role de execução da Lambda"
  type        = string
}

variable "function_name" {
  type        = string
  description = "Nome da função Lambda"
}