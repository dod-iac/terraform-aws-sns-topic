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

Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 is not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_policy\_document | The contents of the access policy attached to the SNS topic.  If not defined, then generates a policy using the "allow\_\*" variables. | `string` | `""` | no |
| allow\_cloudwatch\_events | Allow CloudWatch events to publish to the SNS topic. | `bool` | `true` | no |
| kms\_master\_key\_id | The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. | `string` | `null` | no |
| lambda\_failure\_feedback\_role\_arn | IAM role for failure feedback | `string` | `null` | no |
| lambda\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic | `string` | `null` | no |
| lambda\_success\_feedback\_sample\_rate | Percentage of success to sample | `number` | `null` | no |
| name | n/a | `string` | n/a | yes |
| tags | A mapping of tags to assign to the SNS Topic. | `map(string)` | <pre>{<br>  "Automation": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the SNS topic. |
| name | The name of the SNS topic. |

