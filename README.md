# Flux CD

## Description

To reconcile manually

```bash
flux reconcile kustomization argocd-config -n flux-system
```

### Installation

[Flux CD Installation Guide](https://fluxcd.io/flux/installation/)

1. Run the following command to install Flux CD:

    ```bash
    curl -s https://fluxcd.io/install.sh | sudo bash
    ```

### Provisioning

1. Provision resources:

    ```bash
    make provision
    ```

2. Manually add repository credentials for the Argo CD repositories:
    - Create `repo-creds.yaml` with your Git credentials:

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
    EOF
    ```

    - Apply the credentials:

    ```bash
    make apply-argo-repo-creds
    ```

3. Port forward Argo CD server:

    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

## Charts

[TrueCharts Description List](https://truecharts.org/charts/description_list#Stable)

### Add Taint and Label to Node Running Wireguard

- Due to network routing, other pods won't have internet access. Use this node primarily for storage and pods that don't need internet. Add a taint and label to the node:

    ```bash
    kubectl taint nodes node1 networkmode=host:NoSchedule
    kubectl label nodes node1 networkmode=host
    ```

### Wireguard Settings to Get Internet Access

- Add the following settings to your Wireguard configuration:

    ```bash
    PostUp = sysctl -w -q net.ipv4.ip_forward=1; iptables -A FORWARD -i §g0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = sysctl -w -q net.ipv4.ip_forward=0; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
    ```

- Find cluster DNS to set client DNS to:

    ```bash
    kubectl -n kube-system get svc | grep kube-dns | awk '{print $3}'
    ```

#### Using Sealed Secrets

1. Install [kubeseal](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#linux)
2. Fetch the Sealed Secrets Public Key:

    ```bash
    kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets --fetch-cert > publickey.pem
    ```

3. Template the secret into a YAML file (`mysecret.yaml`):
4. Seal the secret:

    ```bash
    kubeseal --format yaml < mysecret.yaml --cert publickey.pem > mysealedsecret.yaml
    ```

5. Commit and push the sealed secret.

#### TODOS

- Swap PostgreSQL secrets to external secrets

#### Monitoring

This guide provides steps to access the Grafana dashboard/Prometheus running on a Kubernetes cluster on a remote Ubuntu server from a local server using an SSH tunnel.

##### Grafana

1. Port forward Grafana service:

    ```bash
    kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
    ```

2. Create an SSH tunnel:

    ```bash
    ssh -L 3000:localhost:3000 username@remote-server
    ```

3. Access Grafana at `http://localhost:3000`
4. Default username is `admin` and the password can be found in the `monitoring/prometheus/prometheus.yaml` file under the `adminPassword` in Grafana block.

##### Prometheus

1. Port forward Prometheus service:

    ```bash
    kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
    ```

2. Create an SSH tunnel:

    ```bash
    ssh -N -L 3001:localhost:9090 username@remote-server
    ```

3. Access Prometheus at `http://localhost:3001`
+++

#### Polaris

Polaris is an tool designed to enforce best practices in Kubernetes configurations. It runs audits on your Kubernetes clusters to ensure they are using best practices, helping to improve the security, efficiency, and reliability of your deployments.

**Why it is useful:**

Polaris helps identify configuration issues that can affect the stability and performance of your Kubernetes applications. By providing actionable insights, it allows teams to proactively address potential problems, ensuring a more robust and secure environment.

**Accessing Polaris Dashboard:**

1. Port forward the Polaris dashboard service:

    ```bash
    kubectl port-forward svc/polaris-dashboard 8080:80 -n polaris
    ```

2. Create an SSH tunnel:

    ```bash
    ssh -L 8080:localhost:8080 username@remote-server
    ```

3. Access Polaris Dashboard at `http://localhost:8080`

#### Kubernetes Dashboard

The Kubernetes Dashboard is a web-based UI for managing Kubernetes clusters. It provides an overview of the cluster’s resources and allows users to deploy containerized applications, troubleshoot, and manage cluster resources.

**Why it is useful:**

The Kubernetes Dashboard simplifies cluster management by providing an intuitive interface to monitor and manage resources, view logs, and troubleshoot issues without needing to use the command line.

**Accessing Kubernetes Dashboard:**

1. Port forward the Kubernetes Dashboard service:

    ```bash
    kubectl port-forward svc/kubernetes-dashboard 8001:443 -n kubernetes-dashboard
    ```

2. Create an SSH tunnel:

    ```bash
    ssh -L 8001:localhost:8001 username@remote-server
    ```

3. Access Kubernetes Dashboard at `https://localhost:8001`

4. Use the Kubernetes Dashboard to manage and monitor your cluster, deploy applications, and troubleshoot issues.
