ui = true

api_addr = "http://127.0.0.1:2200"
cluster_addr = "http://127.0.0.1:2201"

listener "tcp" {
    tls_disable = 1
    address = "127.0.0.1:2200"
    cluster_address = "127.0.0.1:2201"
    telemetry {
    unauthenticated_metrics_access = true
     }
 }
 
storage "raft" {
    path = "./data2"
    node_id="node2"
    retry_join {
    leader_api_addr = "http://127.0.0.1:8200"
  }
  }

seal "gcpckms" {
  credentials = "cred.json"
  project     = "my-project-1234-285014"
  region      = "global"
  key_ring    = "catalina"
  crypto_key  = "vault"
}
