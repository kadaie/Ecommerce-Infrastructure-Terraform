variable "comment" {
  description = "Distribution comment"
  type        = string
}

variable "origin_domain_name" {
  description = "Domain name of origin"
  type        = string
}
variable "tags" {
  description = "Tags for the distribution"
  type        = map(string)
  default     = {}
}