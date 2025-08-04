#!/bin/bash

# Ensure ISTIO_HOME is set to the correct location
ISTIO_VERSION="1.26.3"
ISTIO_HOME="$HOME/istio-$ISTIO_VERSION"
export PATH="$ISTIO_HOME/bin:$PATH"

echo "🔍 Using ISTIO_HOME=$ISTIO_HOME"

# Install Prometheus
echo "📦 Installing Prometheus..."
kubectl apply -f "$ISTIO_HOME"/samples/addons/prometheus.yaml

# Install Grafana
echo "📦 Installing Grafana..."
kubectl apply -f "$ISTIO_HOME"/samples/addons/grafana.yaml

# Install Jaeger
echo "📦 Installing Jaeger..."
kubectl apply -f "$ISTIO_HOME"/samples/addons/jaeger.yaml

# Install Kiali
echo "📦 Installing Kiali..."
kubectl apply -f "$ISTIO_HOME"/samples/addons/kiali.yaml

# Wait for all pods in istio-system to be ready
echo "⏳ Waiting for all addon pods to be ready..."
kubectl wait --for=condition=available deployment --all -n istio-system --timeout=120s

echo "✅ All Istio addons have been installed!"

echo "🌐 You can now access them using port-forward:"
echo "🔸 Prometheus: kubectl port-forward svc/prometheus -n istio-system 9090:9090"
echo "🔸 Grafana: kubectl port-forward svc/grafana -n istio-system 3000:3000"
echo "🔸 Kiali: kubectl port-forward svc/kiali -n istio-system 20001:20001"
echo "🔸 Jaeger: kubectl port-forward svc/jaeger-query -n istio-system 16686:16686"
