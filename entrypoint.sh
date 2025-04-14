#!/bin/bash

# Start Minikube
minikube start \
  --driver=docker \
  --kubernetes-version=v1.25.9 \
  --addons=metrics-server,ingress,dashboard 

# Deploy ShinyProxy
if [ -d /shinyproxy/kustomize/base ]; then
  kustomize build ../../shinyproxy/kustomize/overlays/dev | kubectl apply -f -
else
  echo "Error: /shinyproxy/kustomize/base directory not found."
  exit 1
fi
