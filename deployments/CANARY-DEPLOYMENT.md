# Canary Deployment for `service-b` in Istio MeshLab

This document explains how canary deployment is configured for `service-b` in the Istio MeshLab project. It covers the purpose of each deployment file, how traffic is split between versions, and how you can experiment or roll back changes.

---

## Overview

- `service-b` has two versions deployed: **v1** and **v2**
- Both versions are exposed via a single Kubernetes Service (`service-b-service.yaml`)
- Istio manages traffic splitting using `VirtualService` and `DestinationRule`
- This setup enables you to route a percentage of traffic to the new version (v2) while the old version (v1) continues to serve most requests—this is called **canary deployment**

---

## File Structure

All files are inside `deployments/service-b/`:

- `service-b-v1-deployment.yaml` — Deploys v1 of the service
- `service-b-v2-deployment.yaml` — Deploys v2 of the service
- `service-b-service.yaml` — Exposes both v1 and v2 Pods as a single service
- `service-b-destination-rule.yaml` — Defines Istio subsets for v1 and v2
- `service-b-virtual-service.yaml` — Splits incoming traffic between v1 and v2
- `service-b-gateway.yaml` *(optional, if exposed externally)*

---

## Deployment Steps

1. **Deploy v1 and v2:**
   ```bash
   kubectl apply -f service-b-v1-deployment.yaml
   kubectl apply -f service-b-v2-deployment.yaml
   ```
Deploy the Service:

```bash
kubectl apply -f service-b-service.yaml
```
Apply the Istio DestinationRule:

```basg
kubectl apply -f service-b-destination-rule.yaml
```
Apply the Istio VirtualService:

```bash
kubectl apply -f service-b-virtual-service.yaml
```
(Optional) Deploy the Gateway if external access is needed:

```bash
kubectl apply -f service-b-gateway.yaml
```
### How Canary Traffic Splitting Works
The DestinationRule defines two subsets: v1 and v2 based on the label version: v1 or version: v2.

The VirtualService specifies the traffic split. For example:

```yaml
http:
  - route:
      - destination:
          host: service-b
          subset: v1
        weight: 80
      - destination:
          host: service-b
          subset: v2
        weight: 20
```
This means 80% of traffic goes to v1, 20% to v2.

### How to Change Traffic Split
To adjust the canary rollout:

Edit service-b-virtual-service.yaml and modify the weight values.

Apply the change:

```bash
kubectl apply -f service-b-virtual-service.yaml
```
### How to Verify
Call the service endpoint (internally or externally, depending on your setup).

Example:

```bash
curl http://service-b.istio-meshlab.svc.cluster.local/hello
```
You should see responses from both v1 and v2 according to the weights.

### Rollback or Promote
- Rollback: Set v1 weight to 100, v2 to 0.
- Promote v2: Set v2 weight to 100, v1 to 0, and optionally remove v1 deployment.

### Troubleshooting Tips
- Ensure all Pods have the correct labels (app: service-b, version: v1 or v2)
- If you see “no healthy upstream/stream” errors, double-check your deployment, service selectors, and DestinationRule labels.
- Confirm that both versions’ Pods are ready and passing liveness/readiness probes.

Happy canary deploying!