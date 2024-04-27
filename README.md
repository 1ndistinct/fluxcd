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

### Add taint and label to node that is running wireguard 
- Due to the network routing, other pods won't have internet connection. We can use this node primarily for storage and pods that don't need internet. Lets add a taint to this node to say as much. 
- `kubectl taint nodes node1 networkmode=host:NoSchedule`
- `kubectl label nodes node1 networkmode=host`
- all pods and deployments that don't need outbound access should be scheduled on this node 



### Wireguard settings to get internet access
- `PostUp = sysctl -w -q net.ipv4.ip_forward=1; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
- `PostDown = sysctl -w -q net.ipv4.ip_forward=0; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE`
- Find cluster DNS to set client DNS to: `kubectl -n kube-system get svc | grep kube-dns | awk '{print $3}'`

#### Using sealed secrets 
1. Install [kubeseal](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#linux)
2. Fetch the Sealed Secrets Public Key - kubeseal uses the public key from the Sealed Secrets controller running in your Kubernetes cluster to encrypt the secret. Fetch the public key using:
  - `kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets --fetch-cert > publickey.pem`
3. template secret into a yaml file for encryption. call it `mysecret.yaml` in this example
4. seal the secret
  - `kubeseal --format yaml < mysecret.yaml --cert publickey.pem > mysealedsecret.yaml`
5. You can then commit and push the sealed secret