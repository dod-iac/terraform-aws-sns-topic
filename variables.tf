variable "allow_cloudwatch_events" {
  type        = bool
  description = "Allow CloudWatch events to publish to the SNS topic."
  default     = true
}

variable "access_policy_document" {
  type        = string
  description = "The contents of the access policy attached to the SNS topic.  If not defined, then generates a policy using the \"allow_*\" variables."
  default     = ""
}

variable "kms_master_key_id" {
  type        = string
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK."
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  type        = string
  description = "The IAM role permitted to receive success feedback for this topic"
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  type        = string
  description = "IAM role for failure feedback"
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  type        = number
  description = "Percentage of success to sample"
  default     = null
}

variable "name" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the SNS Topic."
  default = {
    Automation = "Terraform"
  }
}
