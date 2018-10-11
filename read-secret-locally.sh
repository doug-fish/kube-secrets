# pass in the index of the secret you want to show, for example ./read-secret-locally.sh 1
kubectl get secret/dougs-secrets -o json | jq -r ".data.dougsecret$1" | base64 --decode
