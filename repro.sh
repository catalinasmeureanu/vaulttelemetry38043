mkdir data
mkdir data2 
mkdir data3

vault server -config=config.hcl 2>/dev/null 1>/dev/null &
vault server -config=config2.hcl 2>/dev/null 1>/dev/null &
vault server -config=config3.hcl 2>/dev/null 1>/dev/null &

sleep 3

export VAULT_ADDR='http://127.0.0.1:8200'

vault operator init -recovery-shares=1 -recovery-threshold=1 > key.txt

sleep 10

RootToken=`grep 'Initial Root Token:' key.txt | awk '{print $NF}'`

echo "$RootToken"

vault status

vault login "$RootToken"

vault operator raft list-peers

for i in {1..10}
do
  vault token create -ttl=1s 
done

vault list /sys/leases/lookup/auth/token/create

echo "Number of expired leases Standby Node 2"

curl \
  --header "X-Vault-Token: $RootToken" \
    'http://127.0.0.1:2200/v1/sys/metrics' | jq > out2.json

cat out2.json | jq '.Gauges[] | select(.Name=="vault.expire.num_leases") | .Value'
 
echo "Number of expired leases Standby Node 3"

curl \
  --header "X-Vault-Token: $RootToken" \
    'http://127.0.0.1:3200/v1/sys/metrics' | jq > out3.json

cat out3.json | jq '.Gauges[] | select(.Name=="vault.expire.num_leases") | .Value'


echo "Number of expired leases Active Node Vault 1"

curl \
  --header "X-Vault-Token: $RootToken" \
    'http://127.0.0.1:8200/v1/sys/metrics' | jq > out.json
    
cat out.json | jq '.Gauges[] | select(.Name=="vault.expire.num_leases") | .Value'
