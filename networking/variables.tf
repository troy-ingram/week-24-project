# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}