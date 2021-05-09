resource "null_resource" "authenticated-emails" {
  triggers = {
    template = local.templates.authenticated-emails
  }
  provisioner "local-exec" {
    command = "echo \"${local.templates.authenticated-emails}\" > ${path.module}/rendered/authenticated-emails.txt"
  }
}

resource "docker_image" "image" { name = "quay.io/oauth2-proxy/oauth2-proxy:latest" }

resource "docker_container" "oauth2" {
  name    = local.name
  image   = docker_image.image.latest
  command = local.commands
  env     = local.envars
  lifecycle {
    ignore_changes  = [user]
  }
  dynamic "labels" {
    for_each = merge(
            var.labels,
            {
              "traefik.http.routers.${lower(local.name)}.rule" : "Host(${join(",", formatlist("`%s`", [for i in tolist(try(var.cnames, [var.name])) : join(".", [i, var.domain])]))})",
              "traefik.http.routers.${lower(local.name)}.service" : local.name,
              "traefik.http.services.${lower(local.name)}.loadbalancer.server.port" : var.okta.oauth_port,
              "traefik.http.middlewares.${lower(local.name)}.headers.sslhost" : join(",", formatlist("`%s`", [for i in tolist(try(var.cnames, [var.name])) : join(".", [i, var.domain])])),
              "traefik.http.middlewares.${lower(local.name)}-compression.compress" : false
            }
    )
    content {
      label = replace(labels.key, "PLACEHOLDER_KEY", local.name)
      value = tobool(
        labels.value == "traefik.enable" || labels.value != "traefik.http.routers.${lower(local.name)}.service" || replace(
          labels.value,
          "Host(",
          ""
        ) == labels.value
        ) ? replace(replace(labels.value, local.name, var.name), "PLACEHOLDER_KEY", local.name
      ) : labels.value
    }
  }
  volumes {
    read_only      = true
    host_path      = abspath("${path.module}/rendered/authenticated-emails.txt")
    container_path = "/authenticated-emails.txt"
  }
  dynamic "networks_advanced" {
    for_each = toset([data.docker_network.backend.name, data.docker_network.frontend.name])
    content {
      name = data.docker_network.backend.name
    }
  }
  depends_on = [null_resource.authenticated-emails]
}
