#!/bin/bash

# Set Istio version
ISTIO_VERSION="1.26.3"
ISTIO_HOME="$HOME/istio-$ISTIO_VERSION"

echo "🔧 Downloading Istio $ISTIO_VERSION into $ISTIO_HOME..."

# Download Istio to user's home directory
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

# Move into the Istio folder
cd "$ISTIO_HOME" || { echo "❌ Failed to enter Istio folder."; exit 1; }

# Add istioctl to PATH for current session
export PATH="$ISTIO_HOME/bin:$PATH"

# Show version to confirm installation
istioctl version

echo "✅ istioctl installed successfully."
echo "👉 To use it permanently, add the following line to your ~/.bashrc or ~/.zshrc:"
echo "export PATH=\"$ISTIO_HOME/bin:\$PATH\""
