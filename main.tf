/**
 * ## Usage
 *
 * Creates an AWS SNS Topic that allows publishing from CloudWatch Events.
 *
 *
 * ```hcl
 * module "alerts" {
 *   source = "dod-iac/sns-topic/aws"
 *
 *   name = format("alerts-%s-%s", var.application, var.environment)
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * To create a SNS topic that uses server side encryption, you first need to create a KMS key.
 *
 * ```hcl
 * module "alerts_kms_key" {
 *   source = "dod-iac/sns-kms-key/aws"
 *
 *   name = format("alerts-%s-%s", var.application, var.environment)
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 *
 * module "alerts" {
 *   source = "dod-iac/sns-topic/aws"
 *
 *   name = format("alerts-%s-%s", var.application, var.environment)
 *   kms_master_key_id = module.alerts_kms_key.aws_kms_key_arn
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "access_policy" {
  count = var.allow_cloudwatch_events || var.allow_snowfamily ? 1 : 0
  dynamic "statement" {
    for_each = var.allow_cloudwatch_events ? [1] : []
    content {
      sid = "AllowCloudWatchEventsPublish"
      actions = [
        "sns:Publish"
      ]
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }
      resources = [
        format("arn:%s:sns:%s:%s:%s",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
          var.name
        )
      ]
    }
  }
  dynamic "statement" {
    for_each = var.allow_snowfamily ? [1] : []
    content {
      sid = "AllowSnowFamilyPublish"
      actions = [
        "sns:Publish"
      ]
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["importexport.amazonaws.com"]
      }
      resources = [
        format("arn:%s:sns:%s:%s:%s",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
          var.name
        )
      ]
    }
  }
}

resource "aws_sns_topic" "main" {
  name                                = var.name
  kms_master_key_id                   = var.kms_master_key_id
  policy                              = length(var.access_policy_document) > 0 ? var.access_policy_document : (var.allow_cloudwatch_events || var.allow_snowfamily ? data.aws_iam_policy_document.access_policy.0.json : null)
  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  tags                                = var.tags
}
