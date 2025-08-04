# istio-mesh-lab
A hands-on microservices lab for learning and demonstrating Istio's core features, including mTLS, traffic splitting, JWT authentication, and resilience testing, using Quarkus-based services in a Kubernetes environment.
Each feature is isolated into its own Git branch to support blog-based learning.

## Available Services

- `service-a`
- `service-b-v1`
- `service-b-v2`

Each exposes `/hello` returning a unique greeting message.

## Feature Branches

| Branch Name                 | Description                                                             |
|-----------------------------|-------------------------------------------------------------------------|
| `master`                    | Base Quarkus projects (no Istio)                                        |
| `feature/istio-setup`       | Istio setup and deploy all quarkus <br/> projects in istio environment. |
| `feature/mtls`              | Mutual TLS enforcement                                                  |
| `feature/traffic-splitting` | Canary deployment & traffic control                                     |
| `feature/jwt-auth`          | Securing APIs with JWT                                                  |
| `feature/resilience`        | Retry, timeout, failover strategies                                     |
| `final`                     | Full integration of all features                                        |
