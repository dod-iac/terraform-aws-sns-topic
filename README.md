<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an AWS SNS Topic that allows publishing from CloudWatch Events.

```hcl
module "alerts" {
  source = "dod-iac/sns-topic/aws"

  name = format("alerts-%s-%s", var.application, var.environment)
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

To create a SNS topic that uses server side encryption, you first need to create a KMS key.

```hcl
module "alerts_kms_key" {
  source = "dod-iac/sns-kms-key/aws"

  name = format("alerts-%s-%s", var.application, var.environment)
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}

module "alerts" {
  source = "dod-iac/sns-topic/aws"

  name = format("alerts-%s-%s", var.application, var.environment)
  kms_master_key_id = module.alerts_kms_key.aws_kms_key_arn
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_document"></a> [access\_policy\_document](#input\_access\_policy\_document) | The contents of the access policy attached to the SNS topic.  If not defined, then generates a policy using the "allow\_*" variables. | `string` | `""` | no |
| <a name="input_allow_cloudwatch_events"></a> [allow\_cloudwatch\_events](#input\_allow\_cloudwatch\_events) | Allow CloudWatch events (events.amazonaws.com) to publish to the SNS topic. | `bool` | `true` | no |
| <a name="input_allow_snowfamily"></a> [allow\_snowfamily](#input\_allow\_snowfamily) | Allow Snow Family (importexport.amazonaws.com) to publish to the SNS topic. | `bool` | `true` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. | `string` | `null` | no |
| <a name="input_lambda_failure_feedback_role_arn"></a> [lambda\_failure\_feedback\_role\_arn](#input\_lambda\_failure\_feedback\_role\_arn) | IAM role for failure feedback | `string` | `null` | no |
| <a name="input_lambda_success_feedback_role_arn"></a> [lambda\_success\_feedback\_role\_arn](#input\_lambda\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback for this topic | `string` | `null` | no |
| <a name="input_lambda_success_feedback_sample_rate"></a> [lambda\_success\_feedback\_sample\_rate](#input\_lambda\_success\_feedback\_sample\_rate) | Percentage of success to sample | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the SNS Topic. | `map(string)` | <pre>{<br>  "Automation": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the SNS topic. |
| <a name="output_name"></a> [name](#output\_name) | The name of the SNS topic. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
