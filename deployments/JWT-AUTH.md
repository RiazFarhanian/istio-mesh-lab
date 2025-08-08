# JWT Authentication in Istio MeshLab

This document describes how to enable and test JWT authentication in your Istio MeshLab environment using an OIDC mock server and Istio security policies.

---

## Overview

This guide walks you through:

- Deploying a mock OIDC (OpenID Connect) server (oidc-mock) to issue JWT tokens and serve JWKS keys.
- Exposing oidc-mock using Kubernetes Service, VirtualService, and Gateway resources.
- Configuring Istio’s PeerAuthentication to allow plaintext HTTP for oidc-mock.
- Configuring Service A to enforce JWT authentication using Istio’s `RequestAuthentication` and `AuthorizationPolicy`.
- End-to-end test: Generate a JWT token with oidc-mock, and call Service A’s `/hello` endpoint with the token.

---

## Prerequisites

- Kubernetes cluster with Istio and CertManager installed.
- Istio MeshLab environment set up with at least Service A.
- kubectl configured to target your cluster and namespace.

---

## 1. Deploy the OIDC Mock Server

Apply the following resources (or the corresponding YAML files):

- **Deployment:** Runs oidc-mock as a Pod.
- **Service:** Exposes oidc-mock on a stable DNS name.
- **VirtualService and Gateway:** Make oidc-mock accessible in the cluster.

Example:

```yaml
# oidc-mock-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: oidc-mock
  namespace: istio-meshlab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: oidc-mock
  template:
    metadata:
      labels:
        app: oidc-mock
    spec:
      containers:
        - name: oidc-server-mock
          image: nayyaracropsey/jwtmock:latest
          ports:
            - containerPort: 80
```
```yaml
# oidc-mock-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: oidc-mock
  namespace: istio-meshlab
spec:
  selector:
    app: oidc-mock
  ports:
    - port: 80
      targetPort: 80
```
Apply the resources:

```bash
kubectl -n istio-meshlab apply -f oidc-mock-deployment.yaml
kubectl -n istio-meshlab apply -f oidc-mock-service.yaml
# ...and your Gateway/VirtualService as needed
```

### 2. Allow Plaintext HTTP to oidc-mock
By default, Istio may block HTTP requests (since the mesh expects mTLS).
Add a PeerAuthentication in PERMISSIVE mode for oidc-mock:
```bash
# oidc-mock-peer-auth.yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: oidc-mock-peer-auth
  namespace: istio-meshlab
spec:
  selector:
    matchLabels:
      app: oidc-mock
  mtls:
    mode: PERMISSIVE
```

### 3. Configure JWT Validation for Service A
- RequestAuthentication tells Istio to validate incoming JWTs using a JWKS URI (from oidc-mock):
```yaml
# service-a-request-auth.yaml
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: service-a-jwt
  namespace: istio-meshlab
spec:
  selector:
    matchLabels:
      app: service-a
  jwtRules:
    - issuer: "http://oidc-mock.local"
      jwksUri: "http://oidc-mock.istio-meshlab.svc.cluster.local/.well-known/jwks.json"
```
- AuthorizationPolicy allows any authenticated user to access Service A’s endpoints:

```yaml
# service-a-authorization-policy.yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: service-a-authz
  namespace: istio-meshlab
spec:
  selector:
    matchLabels:
      app: service-a
  rules:
    - from:
        - source:
            requestPrincipals: ["*"]
```
### 4. Update /etc/hosts for OIDC-Mock
To allow your local system and test tools (like curl or Postman) to resolve the OIDC-Mock service (oidc-mock.local), add the following entry to your /etc/hosts file. This step ensures that requests to http://oidc-mock.local are routed correctly to your local Kubernetes cluster via Minikube tunnel or your Ingress/Gateway setup.

1. Find the IP address assigned to your OIDC-Mock service or your Istio ingress gateway.
For example, if you’re using Minikube tunnel, you can check with:

```bash
kubectl get svc -n istio-meshlab
```
Look for the EXTERNAL-IP of your Istio ingress gateway.

2. Edit your /etc/hosts file (you’ll need admin/root privileges):

```bash
sudo nano /etc/hosts
```

3. Add the following line (replace <EXTERNAL-IP> with the actual IP you found):

```bash
<EXTERNAL-IP>   oidc-mock.local
```
Example:

```bash
127.0.0.1   oidc-mock.local
```

4. Save and close the file.

Now, your local tools can resolve oidc-mock.local to the correct service endpoint.


### 5. Test the Setup
#### a. Verify OIDC-Mock is Running
Before generating a JWT, confirm that the OIDC-Mock service is up by retrieving its JWKS (JSON Web Key Set):

```bash
curl http://oidc-mock.local/.well-known/jwks.json
```
- If the service is working, this command should return a JSON response containing the keys array.
- If you receive a connection error, double-check that your /etc/hosts entry is correct and that the OIDC-Mock service is running.

Example successful response:

```json
{
  "keys": [
    {
      "kty": "RSA",
      "alg": "RS256",
      "e": "AQAB",
      "kid": "dCYhYyNMiwCWdOkS",
      "use": "sig",
      "n": "...",
      "x5c": [
        "..."
      ],
      "x5t": "14aa9b0432589257c63967152167d30b043821fd"
    }
  ]
}
```


#### b. Generate a JWT token
- Use the oidc-mock /jwtmock/generate-jwt endpoint to generate a token. For example, with curl:

```bash
curl -X POST http://oidc-mock.local/jwtmock/generate-jwt \
-H "Content-Type: application/json" \
-d '{                                                                                                                                         
    "sub": "riaz",
    "iat": 1754620279,
    "exp": 1754706679,
    "iss": "http://oidc-mock.local"
  }'
```
- Note: Ensure the iss matches what you configured in the RequestAuthentication.

#### c. Call Service A with the JWT
- Use curl or Postman to call your Service A endpoint, adding the Authorization header:

```bash
curl -vk https://service-a.local/hello \
-H "Authorization: Bearer <your-jwt-token-here>"
```
If the token is valid, you should receive a 200 OK with the response from Service A.
If invalid, you will get a 401 Unauthorized and a message like "Jwt verification fails".

### Troubleshooting
- 401 Unauthorized: Double-check that your iss and jwksUri are correct and reachable by the Istio proxy.
- Cluster networking: If oidc-mock.local is not resolvable, use the full cluster DNS: http://oidc-mock.istio-meshlab.svc.cluster.local/.well-known/jwks.json.
- Peer Authentication: Make sure PERMISSIVE mode is set for oidc-mock so the JWKS can be fetched in plain HTTP.

### Summary
- You now have a mock OIDC issuer in your cluster.
- Service A is secured with JWT validation at the Istio sidecar level.
- End-to-end JWT-based auth is working and tested!