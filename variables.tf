variable "cnames" { type = list(string) }
variable "cookie_expire" { default = 672 }
variable "cookie_httponly" { default = false }
variable "cookie_name" { default = "_oauth2_proxy" }
variable "cookie_refresh" { default = 24 }
variable "cookie_secure" { default = true }
variable "customResponseHeaders" { type = string }
variable "domain" { type = string }
variable "emails" { type = list(string) }
variable "envars" {}
variable "labels" {}
variable "name" {}
variable "networks" { type = list(string) }
variable "oidc_provider" { default = "oidc" }
variable "okta" {}
variable "okta_url" { default = "oktapreview.com" }
variable "organizr_cname" { type = string }
variable "provider_name" { default = "okta" }
variable "request_logging" { default = false }
variable "scope" { default = "openid email" }
variable "session_store_type" { default = "cookie" }
variable "skip_provider_button" { default = true }
variable "STSSeconds" { type = number }
variable "upstream_url" { type = string }
variable "verification" { default = true }

variable "network_backend" {
  type    = string
  default = "backend"
}

variable "network_frontend" {
  type    = string
  default = "frontend"
}
