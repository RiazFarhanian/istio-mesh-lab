# Istio Setup – Istio MeshLab

This directory provides everything needed to bootstrap your Istio environment for the MeshLab project. It includes scripts to install the Istio CLI, deploy observability add-ons, and prepare your custom namespace for service mesh injection.

---

## 📁 Contents

| File Name                | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| `install-istioctl.sh`   | Installs the `istioctl` CLI tool into the user's home directory.            |
| `install-istio-addons.sh` | Deploys observability add-ons like Kiali, Prometheus, Grafana, and Jaeger. |
| `namespace.yaml`        | Creates the `istio-meshlab` namespace and enables sidecar injection.        |

---

## 🛠️ Setup Instructions

### 1. Install Istio CLI (istioctl)

Use this script to download and install the `istioctl` command-line tool into your home directory and add it to your PATH:

```bash
chmod +x install-istioctl.sh 
./install-istioctl.sh
```

This script will:
Download the latest Istio version (default: 1.26.3).
Extract it to ~/istio-1.26.3.
Append the CLI path to your shell config (~/.bashrc, ~/.zshrc, etc.).
After installation, verify with:
```bash
istioctl version
```

### 2. Create the Namespace
Before deploying services, you need a dedicated namespace with Istio sidecar injection enabled.
Apply the namespace config:
```bash
kubectl apply -f namespace.yaml
```
This will create a namespace called istio-meshlab with automatic Envoy sidecar injection.
### 3. Install Istio Add-ons (Kiali, Grafana, etc.)
   After installing istioctl, deploy Istio's observability tools:
```bash
chmod +x install-istio-addons.sh 
./install-istio-addons.sh
```
This script fetches the official Istio addons.yaml from the GitHub repo and applies it to the cluster. It installs:
- Kiali: Mesh visualizer
- Grafana: Metrics dashboard
- Prometheus: Metrics collector
- Jaeger: Distributed tracing

To launch the dashboards:

```bash
istioctl dashboard kiali
istioctl dashboard grafana
istioctl dashboard prometheus
istioctl dashboard jaeger
```


