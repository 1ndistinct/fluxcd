## Flux CD
### Installation 
- https://fluxcd.io/flux/installation/
1. `curl -s https://fluxcd.io/install.sh | sudo bash`

### Provisioning 
1. `make provision` 
2. Need to manually add repo creds for the argocd repos 
    - add the below to repo-creds.yaml and replace password and username with your git token 
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
  url: https://github.com/1ndistinct
  password: my-password
  username: my-username
```
    - run to apply `make apply-argo-repo-creds`
3. Port forward argocd to use it `kubectl port-forward svc/argocd-server -n argocd 8080:443`

## Charts
- https://truecharts.org/charts/description_list#Stable

