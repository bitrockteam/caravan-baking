# Pino Baking

#### Test list

| Test name | Context |test input|output to test|
| :-------------------: |:-----:|:----:|:-----:|
|Consul|network|consul.sh|assert $INTERFACE|
|OS|network|dummy-nic.service|assert $DUMMY_IP|
|Consul|application|version|assert version equal to .. |
|Vault|application|version|assert version equal to ..|
|Nomad|application|version|assert version equal to ..|
|Envoy|application|version|assert version equal to ..|
|Docker|application|version|assert version equal to ..|
|CNI|application|version|assert version equal to ..|