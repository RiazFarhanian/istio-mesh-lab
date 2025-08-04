#!/bin/bash

# Set Istio version
ISTIO_VERSION="1.26.3"
export ISTIO_HOME="$HOME/istio-$ISTIO_VERSION"

echo "Move to Home folder($HOME)"
# shellcheck disable=SC2164
cd "$HOME"

echo "🔧 Downloading Istio $ISTIO_VERSION into $ISTIO_HOME..."

# Download Istio to user's home directory
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

# Move into the Istio folder
cd "$ISTIO_HOME" || { echo "❌ Failed to enter Istio folder."; exit 1; }

echo "Copying istioctl to bin folder for terminal usage"
sudo ln -sf "$ISTIO_HOME/bin/istioctl" /usr/local/bin/istioctl

if [[ "$SHELL" == *"zsh" ]]; then
  echo "export PATH=\"$ISTIO_HOME/bin:\$PATH\"" >> ~/.zshrc
  echo "export ISTIO_HOME=\"$ISTIO_HOME\"" >> ~/.zshrc
  echo "🔁 Added istioctl to ~/.zshrc"
elif [[ "$SHELL" == *"bash" ]]; then
  echo "export PATH=\"$ISTIO_HOME/bin:\$PATH\"" >> ~/.bashrc
  echo "export ISTIO_HOME=\"$ISTIO_HOME\"" >> ~/.bashrc
  echo "🔁 Added istioctl to ~/.bashrc"
else
  echo "⚠️ Unknown shell, please add this to your shell config manually:"
  echo "export PATH=\"$ISTIO_HOME/bin:\$PATH\""
  echo "export ISTIO_HOME=\"$ISTIO_HOME\""
fi

# Confirm installation
echo "📦 istioctl binary location: $(which istioctl)"
echo "🔍 Istio version:"
istioctl version || { echo "❌ Failed to retrieve istio version"; exit 1; }

# Install Istio into the Kubernetes cluster (demo profile)
echo "🚀 Installing Istio into the cluster using the 'demo' profile..."
istioctl install --set profile=demo -y

# Verify installation
echo "✅ Istio installed successfully into the cluster."
