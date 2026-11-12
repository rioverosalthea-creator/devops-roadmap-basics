# Infrastructure as Code (IaC): describe what you want, Terraform makes it so.
# This lab uses the "local" provider, so no cloud account is needed.
# The same plan → apply → destroy workflow is used for AWS, Azure and GCP.

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "student_name" {
  description = "Your name"
  type        = string
  default     = "DevOps Student"
}

resource "local_file" "welcome" {
  filename = "${path.module}/output/welcome.txt"
  content  = "Hello ${var.student_name}! This file was created by Terraform.\n"
}

output "file_created" {
  value = local_file.welcome.filename
}
