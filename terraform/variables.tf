variable "region" {
  default = "eu-west-1"
}

variable "iam_username" {
  description = "The IAM user whose keys will be rotated"
}

variable "secrets_manager_arn" {
  description = "ARN of the Secrets Manager secret to store the new keys"
}
