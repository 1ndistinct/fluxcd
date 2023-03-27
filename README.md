### Flux CD
- https://fluxcd.io/flux/installation/
1. `curl -s https://fluxcd.io/install.sh | sudo bash`

2. Need to manually add repo creds for the argocd repos - add the below to repo-creds.yaml and replace password and username
- kubectl apply -f repo-creds.yaml
```yaml
kubectl apply -f <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repo-creds
stringData:
  type: git
  url: https://github.com/Wednesday-Vibes
  password: my-password
  username: my-username
```