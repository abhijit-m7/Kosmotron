# Kosmotron GitOps Setup

## Directory Structure

```
Kosmotron/
├── bootstrap.sh                    # Script to create clusters and install Flux
├── clusters/
│   ├── management/                 # Management cluster configs
│   │   └── kind-config.yaml
│   └── workloads/                  # Workload cluster configs
│       └── kind-config.yaml
├── workload-clusters/              # K0smotron/CAPI cluster definitions
│   └── example-cluster.yaml
└── applications/
    ├── base/                       # Flux sources & Helm repos
    │   ├── flux-sources.yaml
    │   └── helm-repositories.yaml
    └── releases/                   # HelmReleases (deploy components here)
        └── nginx-ingress.yaml
```

## Quick Start

1. **Create clusters and install Flux:**
   ```bash
   bash bootstrap.sh
   ```

2. **Point kubectl to management cluster:**
   ```bash
   kubectl config use-context kind-management
   ```

3. **Deploy a component to workload cluster:**
   
   Create a HelmRelease in `applications/releases/`, then push to your Git repo.
   Flux will detect changes and deploy automatically.

## Adding New Components

1. Add HelmRelease to `applications/releases/`
2. Commit and push to Git
3. Flux reconciles automatically

## Local Development Workflow

1. Edit files in `applications/releases/`
2. Apply locally first: `kubectl apply -f applications/releases/`
3. When ready, commit to Git for GitOps reconciliation
