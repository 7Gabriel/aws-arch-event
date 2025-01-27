variable "cluster_identifier" {
  type        = string
  description = "ecommerce-aurora-cluster"
}

variable "engine" {
  type        = string
  default     = "aurora-mysql"
  description = "aurora-mysql"
}

variable "engine_mode" {
  type        = string
  default     = "serverless"
  description = "serverless"
}

variable "master_username" {
  type        = string
  description = "admin"
}

variable "master_password" {
  type        = string
  description = "Autogerenciada"
}

variable "database_name" {
  type        = string
  description = "ecommerce"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Período de retenção do backup em dias"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Proteção contra exclusão do cluster"
}

variable "availability_zones" {
  type        = list(string)
  description = "Lista de zonas"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "Número de instâncias no cluster Aurora"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Classe de instância do Aurora"
}

variable "tags" {
  type        = map(string)
  default     = {
    Environment = "Dev"
  }
  description = "Tags para os recursos do Aurora"
}

variable "private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC"
  type        = list(string)
}


variable "vpc_security_group_ids" {
  description = "IDs dos grupos de segurança da VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID da VPC associada ao cluster Aurora"
  type        = string
}

