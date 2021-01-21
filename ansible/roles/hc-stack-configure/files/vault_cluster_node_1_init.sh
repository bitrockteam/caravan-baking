#!/bin/bash
for arg in $@; do
  [[ $arg =~ ^[a-z_]+=.*$ ]] && export $arg
done

set -e
sudo ls -la /etc/vault.d/
sudo systemctl start vault && \
vault status -address=http://127.0.0.1:8200 | grep -q 'Initialized *true' && exit 0 || {
  sleep 10s && \
  systemctl status vault && \
  vault operator init -address=http://127.0.0.1:8200 | \
  awk '/Root Token/{print $4}' | \
  sudo tee /root/root_token
}
sleep 10s
export VAULT_TOKEN=`sudo cat /root/root_token` VAULT_ADDR=http://127.0.0.1:8200 && \
#### enable kv secret engine (version 2)
vault secrets enable -path=secret kv-v2 && \
#### enable nomad secret engine
vault secrets enable nomad && \
#### consul/connect/nomad pki
# enable pki
vault secrets enable -path=tls_pki pki && \
# tune TTL
vault secrets tune -max-lease-ttl=8760h tls_pki && \
# generate CA for Consul
vault write -field=certificate tls_pki/root/generate/internal common_name="consul" ttl=8760h && \
# generate Consul CA issuing urls
vault write tls_pki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/tls_pki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/tls_pki/crl" && \
# enable another pki, acting as intermediate CA
vault secrets enable -path=tls_pki_int pki && \
# tune TTL
vault secrets tune -max-lease-ttl=43800h tls_pki_int && \
# generate Intermediate CA sign request for Consul
vault write -format=json tls_pki_int/intermediate/generate/internal common_name="consul Intermediate Authority" alt_names="localhost,127.0.0.1" ip_sans="127.0.0.1" | jq -r '.data.csr' | tee tls_pki_intermediate.csr && \
# let CA sign intermediate sign request
vault write -format=json tls_pki/root/sign-intermediate csr=@tls_pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' | tee intermediate.cert.pem && \
# put cert in intermediate CA
vault write tls_pki_int/intermediate/set-signed certificate=@intermediate.cert.pem && \
# create intermediate roles for consul and nomad
vault write tls_pki_int/roles/consul allowed_domains="consul,127.0.0.1" allow_subdomains=true max_ttl="720h" && \
vault write tls_pki_int/roles/nomad allowed_domains="nomad,127.0.0.1" allow_subdomains=true max_ttl="720h" && \
# clean up
rm tls_pki_intermediate.csr intermediate.cert.pem
# add counters
vault write sys/internal/counters/config enabled=enable
