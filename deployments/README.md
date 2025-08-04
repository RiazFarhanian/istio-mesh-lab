# 📦 Istio MeshLab: Deployments Guide

The deployments consist of three services (`service-a`, `service-b-v1`, and `service-b-v2`), each with:

- A Kubernetes Deployment
- A Kubernetes Service
- An Istio VirtualService
- An Istio Gateway
- A TLS certificate via cert-manager

---

## 🧱 Folder Structure

```
deployments/
├── namespace.yaml
├── cluster-issuer.yaml
├── service-a/
│   ├── service-a-deployment.yaml
│   ├── service-a-service.yaml
│   ├── service-a-virtualservice.yaml
│   ├── service-a-gateway.yaml
│   ├── service-a-certificate.yaml
├── service-b-v1/
│   ├── service-b-v1-deployment.yaml
│   ├── service-b-v1-service.yaml
│   ├── service-b-v1-virtualservice.yaml
│   ├── service-b-v1-gateway.yaml
│   ├── service-b-v1-certificate.yaml
├── service-b-v2/
    ├── service-b-v2-deployment.yaml
    ├── service-b-v2-service.yaml
    ├── service-b-v2-virtualservice.yaml
    ├── service-b-v2-gateway.yaml
    ├── service-b-v2-certificate.yaml
```

---

## 📌 Prerequisites

Make sure you have:

- Minikube running
- Istio installed and running
- cert-manager installed using the following commands:

### Install cert-manager CRDs (via online URL)

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.2/cert-manager.crds.yaml
kubectl apply -f cluster-issuer.yaml
```

---

## ✅ Setup Steps

### 1. Set Docker to use Minikube environment

```bash
eval $(minikube docker-env)
```

Note: This ensures Docker builds images inside the Minikube VM.
Warning: 

---

### 2. Create the namespace

```bash
kubectl apply -f deployments/namespace.yaml
kubectl config set-context --current --namespace=istio-meshlab
```

---

### 3. Deploy the services

For each service (e.g., `service-a`, `service-b-v1`, etc.), apply the YAML files in order:

```bash
kubectl apply -f deployments/service-a/service-a-deployment.yaml
kubectl apply -f deployments/service-a/service-a-service.yaml
kubectl apply -f deployments/service-a/service-a-certificate.yaml
kubectl apply -f deployments/service-a/service-a-gateway.yaml
kubectl apply -f deployments/service-a/service-a-virtualservice.yaml
```

Repeat similarly for `service-b-v1` and `service-b-v2`.

---

### 4. Get Istio Ingress Gateway IP

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

> If using Minikube:
```bash
minikube tunnel
```

### 5. Update `/etc/hosts`

Map your service hostname to the ingress IP:

```
127.0.0.1  service-a.local
127.0.0.1  service-b-v1.local
127.0.0.1  service-b-v2.local
```

> Update with actual External IP of istio-ingressgateway if different.

```
EXTERNAL-IP  service-a.local
EXTERNAL-IP  service-b-v1.local
EXTERNAL-IP  service-b-v2.local
```

## 🔐 TLS Certificates

Each service uses a self-signed certificate issued via cert-manager.

- Issuer: `ClusterIssuer` defined earlier
- Credential names used in Gateway:
    - `service-a-tls`
    - `service-b-v1-tls`
    - `service-b-v2-tls`

Make sure certificate names match the `credentialName` in your `Gateway` definitions.

---

## 🧪 Test Your Services

Once deployed, you can test with:

```bash
curl https://service-a.local/hello
```

Expected response:

```
Greeting from Service A
```

---

## 📎 Notes

- Each service is isolated in its own subfolder with self-contained YAML files.
- Gateway and VirtualService files allow Istio to manage external access and traffic routing.
- All services are assumed to respond under the `/hello` endpoint for demo purposes.
- Certificates will automatically create `Secrets` in the namespace
- Gateways must match `credentialName` with the secret name from the Certificate
- VirtualService must route to the service name as defined in Kubernetes

---

Happy Service Meshing! 🎉