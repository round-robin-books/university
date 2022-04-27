#!/bin/zsh

echo "==> Adding and Updating the Redpanda chart repository..."
helm repo add redpanda https://charts.vectorized.io/ && \
helm repo update

export VERSION=$(curl -s https://api.github.com/repos/redpanda-data/redpanda/releases/latest | jq -r .tag_name)
echo "==> Setting the VERSION environment variable to latest version ($VERSION)" 

echo "==> Installing the Redpanda operator CRD (using zsh)..."
noglob kubectl apply \
-k https://github.com/redpanda-data/redpanda/src/go/k8s/config/crd?ref=$VERSION

echo "==> Installing the Redpanda operator on the Kubernetes cluster..."
helm install \
  redpanda-operator \
  redpanda/redpanda-operator \
  --namespace redpanda-system \
  --create-namespace \
  --version $VERSION
