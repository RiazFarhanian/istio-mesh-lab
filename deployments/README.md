# 📦 Istio MeshLab: Deployments Guide

This folder contains all the Kubernetes deployment configurations for the Istio MeshLab project.

---

## 📁 Folder Structure

```
deployments/
│
├── namespace.yaml                  # Namespace configuration
│
├── service-a/
│   ├── service-a-deployment.yaml
│   ├── service-a-service.yaml
│   ├── service-a-virtualservice.yaml
│   └── service-a-gateway.yaml
│
├── service-b-v1/
│   ├── service-b-v1-deployment.yaml
│   ├── service-b-v1-service.yaml
│   ├── service-b-v1-virtualservice.yaml
│   └── service-b-v1-gateway.yaml
│
└── service-b-v2/
    ├── service-b-v2-deployment.yaml
    ├── service-b-v2-service.yaml
    ├── service-b-v2-virtualservice.yaml
    └── service-b-v2-gateway.yaml
```

---

## 🚀 Deployment Steps

> 🧠 **Before You Begin:** Make sure you have Istio and your Kubernetes cluster (e.g., Minikube) up and running.

### ✅ Step 1: Create the Namespace

All services are deployed into the `istio-meshlab` namespace.

```bash
kubectl apply -f namespace.yaml
```

---

### 🔁 Step 2: Deploy Each Service

Repeat these steps for each service folder: `service-a`, `service-b-v1`, and `service-b-v2`.

> 💡 Replace `service-a` with the respective service name when applying the resources.

#### 2.1 Deploy Application

```bash
kubectl apply -f service-a/service-a-deployment.yaml
```

This creates the deployment for the application (Pods).

#### 2.2 Expose the Service

```bash
kubectl apply -f service-a/service-a-service.yaml
```

This exposes the Pods internally via a ClusterIP service.

#### 2.3 Apply Istio Virtual Service

```bash
kubectl apply -f service-a/service-a-virtualservice.yaml
```

This configures the routing rules for the service within the mesh.

#### 2.4 Apply Istio Gateway

```bash
kubectl apply -f service-a/service-a-gateway.yaml
```

This exposes the service externally through Istio's ingress gateway.

---

## 🌐 Accessing the Services

After deploying all components, you can access the services via browser or `curl`.

### 1. Get Istio Ingress Gateway IP

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

> If using Minikube:
```bash
minikube tunnel
```

### 2. Update `/etc/hosts`

Map your service hostname to the ingress IP:

```
127.0.0.1  service-a.local
127.0.0.1  service-b-v1.local
127.0.0.1  service-b-v2.local
```

> Update with actual IP if different.

### 3. Test the Endpoint

```bash
curl http://service-a.local/hello
```

Expected response:

```
Greeting from Service A
```

---

## 🛠 Notes

- Each service is isolated in its own subfolder with self-contained YAML files.
- Gateway and VirtualService files allow Istio to manage external access and traffic routing.
- All services are assumed to respond under the `/hello` endpoint for demo purposes.

---

Happy Mesh-ing! 🕸️
