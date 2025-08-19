# Enabling Mutual TLS (mTLS) for Internal Service Communication

## Overview

This document explains how **mutual TLS (mTLS)** is enabled for secure communication between services in the Istio MeshLab project, specifically between **Service A** and **Service B**.

With mTLS enabled, **all traffic between pods in the mesh is transparently encrypted and authenticated**, ensuring both privacy and strong identity without requiring any changes in application code.

---

## Scenario

- **Service A** exposes a `/api/client/hello` endpoint.
- When `/api/client/hello` is called, Service A internally calls Service B’s `/api/greeting/hello` endpoint.
- The communication between Service A and Service B should be **secured using Istio-managed mutual TLS**.

---

## Files Added

### 1. `istio-mtls-peer-auth.yaml`

**Purpose:**  
Enforces that all pods in the `istio-meshlab` namespace must **receive traffic via mTLS only** (STRICT mode).

**Example:**
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: strict-mtls
  namespace: istio-meshlab
spec:
  mtls:
    mode: STRICT
```



#### What this does:

Rejects all plaintext (non-mTLS) traffic.

Only encrypted and mutually authenticated connections are accepted by all services in this namespace.

### 2. service-b-v1-destination-rule.yaml
Purpose:
Ensures that all clients in the mesh send outbound traffic to Service B using mTLS.

Example:

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: service-b-mtls
  namespace: istio-meshlab
spec:
  host: service-b
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
```
#### What this does:

Tells Istio’s sidecars to always use mTLS when connecting to service-b.

Guarantees that even if the mesh allows mixed (plaintext + mTLS) traffic elsewhere, this service always gets encrypted, authenticated requests.

## How it Works
Application code remains unchanged — Service A still calls Service B using standard HTTP:

```
http://service-b/api/client/hello
```

Istio sidecars intercept all network traffic between pods.

All network connections between Service A and Service B are transparently upgraded to mTLS.

Certificates and keys are managed automatically by Istio; you do not need to handle any PKI operations.

## Benefits of This Setup
- Encryption: Data in transit is always encrypted between pods.
- Authentication: Only trusted workloads (with valid Istio-issued certificates) can talk to each other.
- No app code changes needed: Security is handled by the mesh infrastructure.

To Apply
Apply the peer authentication rule:

```bash
kubectl apply -f deployments/istio-mtls-peer-auth.yaml -n istio-meshlab
```

Apply the destination rule:

```bash
kubectl apply -f deployments/service-b-v1-destination-rule.yaml -n istio-meshlab
```
Deploy or redeploy your services as usual.