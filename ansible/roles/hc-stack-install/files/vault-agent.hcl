pid_file = "/var/lib/vault/vault.pid"

vault {
  address = "https://vault.service.consul:8200"
}

cache {
  use_auto_auth_token = true
}

listener "unix" {
  address     = "/var/lib/vault/vault.socket"
  tls_disable = true
}

listener "tcp" {
  address     = "127.0.0.1:8100"
  tls_disable = true
}
