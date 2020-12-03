locals {
  name = "${var.name}-proxy"
  commands = [
    "--authenticated-emails-file=/authenticated-emails.txt",
    "--client-id=${var.okta.client_id}",
    "--client-secret=${var.okta.client_secret}",
    "--cookie-domain=${var.domain}",
    "--cookie-expire=${var.cookie_expire}h",
    "--cookie-httponly=${var.cookie_httponly}",
    "--cookie-name=${var.cookie_name}",
    "--cookie-refresh=${var.cookie_refresh}h",
    "--cookie-secret=${var.okta.cookie_secret}",
    "--cookie-secure=${var.cookie_secure}",
    "--http-address=http://0.0.0.0:${var.okta.oauth_port}",
    "--insecure-oidc-allow-unverified-email=${var.verification}",
    "--insecure-oidc-skip-issuer-verification=${var.verification}",
    "--oidc-issuer-url=https://${replace(var.domain, ".com", "")}.${var.okta_url}/oauth2/default",
    "--provider-display-name=${var.provider_name}",
    "--provider=${var.oidc_provider}",
    "--redirect-url=https://${var.cnames.0}.${var.domain}/oauth2/callback",
    "--scope=${var.scope}",
    "--session-store-type=${var.session_store_type}",
    "--skip-provider-button=${var.skip_provider_button}",
    "--ssl-insecure-skip-verify=${var.verification}",
    "--ssl-upstream-insecure-skip-verify=${var.verification}",
    "--upstream=${var.upstream_url}",
    "--whitelist-domain=.${var.domain}",
  ]
  templates = {
    authenticated-emails = templatefile("./templates/authenticated-emails.tmpl", {
      emails = var.emails
    })
  }
  labels = var.labels
  envars = var.envars
}
