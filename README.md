This is used to create a Vault cluster with 3 Vault nodes with raft storage. Vault is initialized and auto-unsealed using GCP Cloud KMS. Vault tokens are created with a short TTL. 

Script returns the number of expired leases for the active and standbys nodes.
