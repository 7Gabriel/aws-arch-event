variable "stream_name" {
  type        = string
  description = "ProcessarPedido"
}

variable "shard_count" {
  type        = number
  default     = 1
  description = "Número de shards no stream"
}
