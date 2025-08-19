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
├── service-b/
    ├── service-b-deployment.yaml
    ├── service-b-service.yaml
    ├── service-b-virtualservice.yaml
    ├── service-b-gateway.yaml
    ├── service-b-certificate.yaml
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


#### 1.1 Build Docker
In `project-root/istio-service/` folder you can run `build-and-dockerize.sh` this will build `istio-service:1.0.0` docker image for further use.

```bash
./build-and-dockerize.sh
```
---

### 2. Create the namespace

```bash
kubectl apply -f deployments/namespace.yaml
kubectl config set-context --current --namespace=istio-meshlab
```

---

### 3. Deploy the services

For each service (e.g., `service-a` and `service-b`), apply the YAML files in order:

```bash
kubectl apply -f deployments/service-a/service-a-deployment.yaml
kubectl apply -f deployments/service-a/service-a-service.yaml
kubectl apply -f deployments/service-a/service-a-certificate.yaml
kubectl apply -f deployments/service-a/service-a-gateway.yaml
kubectl apply -f deployments/service-a/service-a-virtualservice.yaml
```
or simply do this instead:

```bash
kubectl apply -f deployments/service-a
```

Repeat similarly for `service-b`.

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
127.0.0.1  service-b.local
```

> Update with actual External IP of istio-ingressgateway if different.

```
EXTERNAL-IP  service-a.local
EXTERNAL-IP  service-b.local
```

## 🔐 TLS Certificates

Each service uses a self-signed certificate issued via cert-manager.

- Issuer: `ClusterIssuer` defined earlier
- Credential names used in Gateway:
    - `service-a-tls`
    - `service-b-tls`

Make sure certificate names match the `credentialName` in your `Gateway` definitions.

---

## 🧪 Test Your Services

Once deployed, you can test with:

```bash
curl https://service-a.local/api/greeting/hello
```

Expected response:

```
Hello from service-a
```

---

## 📎 Notes

- Each service is isolated in its own subfolder with self-contained YAML files.
- Gateway and VirtualService files allow Istio to manage external access and traffic routing.
- All services are assumed to respond under the `/api/greeting/hello` endpoint for demo purposes.
- Certificates will automatically create `Secrets` in the namespace
- Gateways must match `credentialName` with the secret name from the Certificate
- VirtualService must route to the service name as defined in Kubernetes

---

Happy Service Meshing! 🎉