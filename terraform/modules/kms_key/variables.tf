variable "name" {
  sensitive   = true
  description = "The name of the KMS key (alias) to create."
  type        = string
}

variable "description" {
  sensitive   = true
  description = "The description of the key as viewed in AWS console."
  type        = string
}

variable "is_enabled" {
  sensitive   = true
  description = "Specifies whether the key is enabled. Defaults to `true`."
  type        = bool
  default     = true
}

variable "multi_region" {
  sensitive   = true
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`."
  type        = bool
  default     = false
}

variable "key_usage" {
  sensitive   = true
  description = "Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`. Defaults to `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  sensitive   = true
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`. For help with choosing a key spec, see the [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/symm-asymm-choose.html)."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "rotation_period_in_days" {
  sensitive   = true
  description = "Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive). Defaults to `365`."
  type        = number
  default     = 365
}

variable "tags" {
  sensitive   = true
  description = "A map of tags to assign to the object."
  type        = map(string)
  default     = {}
}

variable "key_policy_statements" {
  sensitive   = true
  description = "A list of additional key policy statements to attach to the key beyond enabling IAM user permissions."
  default     = []

  type = list(object({
    Sid       = string
    Effect    = string
    Action    = any
    Resource  = any
    Principal = any
    Condition = optional(any)
  }))
}
