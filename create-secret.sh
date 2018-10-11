kubectl create secret generic dougs-secrets \
  --from-file dougsecret1 \
  --from-file dougsecret2 \
  --from-file dougsecret3
