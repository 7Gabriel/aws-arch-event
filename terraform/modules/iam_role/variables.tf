variable "role_name" {
  type        = string
  description = "Nome da role para Lambda"
  default     = "lambda_execution_role"
}

variable "kinesis_stream_arn" {
  description = "ARN do stream Kinesis usado pelas Lambdas"
  type        = string
}