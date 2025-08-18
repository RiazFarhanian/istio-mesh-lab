# istio-mesh-lab
A hands-on microservices lab for learning and demonstrating Istio's core features, including mTLS, traffic splitting, JWT authentication, and resilience testing, using Quarkus-based services in a Kubernetes environment.
Each feature is isolated into its own Git branch to support blog-based learning.

## Available Services

### `istio-service`

- This service exposes `/api/greeting/hello` returning a unique greeting message.
- Another endpoint is `/api/client/hello` returning a greeting from an api call.

## Feature Branches

| Branch Name           | Description                         |
|-----------------------|-------------------------------------|
| `master`              | Base Quarkus projects (no Istio)    |
| `feature/mtls`        | Mutual TLS enforcement              |
| `feature/traffic-splitting` | Canary deployment & traffic control |
| `feature/jwt-auth`    | Securing APIs with JWT              |
| `feature/resilience`  | Retry, timeout, failover strategies |
| `final`               | Full integration of all features    |
