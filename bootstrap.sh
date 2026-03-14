#!/bin/bash

set -e

export PATH="$PATH:/c/Users/Abhijit Menon/AppData/Local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIND="kind.exe"
KUBECTL="kubectl"

echo "=== Creating Management Cluster ==="
$KIND create cluster --name management --config "$SCRIPT_DIR/clusters/management/kind-config.yaml"

echo "=== Creating Workload Cluster ==="
$KIND create cluster --name workload-1 --config "$SCRIPT_DIR/clusters/workloads/kind-config.yaml"

echo "=== Installing Flux on Management Cluster ==="
$KUBECTL --context kind-management apply -k https://github.com/fluxcd/flux2/installation?ref=v2.4.0

echo "=== Waiting for Flux to reconcile ==="
$KUBECTL --context kind-management -n flux-system wait deploy source-controller --for=condition=ready --timeout=5m
$KUBECTL --context kind-management -n flux-system wait deploy helm-controller --for=condition=ready --timeout=5m

echo "=== Setup complete! ==="
echo ""
echo "Management cluster: kind-management"
echo "Workload cluster: kind-workload-1"
echo ""
echo "To deploy to workload cluster, create HelmRelease in: applications/releases/"
