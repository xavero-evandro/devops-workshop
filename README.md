# DevOps Workshop (Application Repository)

This repository contains the **application source code** for the workshop project:

- **Backend**: .NET 8 API (`apps/backend/YoutubeLiveApp`)
- **Frontend**: Next.js 14 app (`apps/frontend/youtube-live-app`)

Kubernetes deployment manifests are managed separately in the GitOps repository:

- **GitOps repo**: `https://github.com/xavero-evandro/devops-workshop-gitops`

---

## Repository Scope

This repo is responsible for:

- application code
- Docker image builds
- CI pipeline to push images to ECR
- promotion trigger to update image tags in the GitOps repo

This repo is **not** the source of truth for runtime Kubernetes manifests anymore.

---

## Branch Strategy

The CI/CD pipeline follows this branch-to-environment model:

- `dev` branch -> promotes to `dev` overlay in GitOps repo
- `staging` branch -> promotes to `staging` overlay in GitOps repo
- `main` branch -> promotes to `prod` overlay in GitOps repo

Environment protection is expected to be configured in GitHub Environments:

- `dev`: no manual approval
- `staging`: no manual approval
- `prod`: manual approval required

---

## CI/CD Overview

Workflow files:

- `.github/workflows/continuous-deployment.yml`
  - builds and pushes backend + frontend images to ECR
  - triggers GitOps promotion based on branch
- `.github/workflows/promote-gitops.yml`
  - reusable workflow
  - updates image tags in GitOps overlay using `kustomize edit set image`

High-level flow:

1. Push to `dev`, `staging`, or `main`
2. GitHub Actions builds and pushes images with tag = commit SHA
3. Workflow updates image tags in `devops-workshop-gitops`
4. ArgoCD detects GitOps change and syncs cluster

---

## Required GitHub Secrets

In this repository (`devops-workshop`), configure:

- `PAT`: token with push access to `xavero-evandro/devops-workshop-gitops`

AWS OIDC role + permissions must allow pushing images to ECR repositories:

- `workshop-backend`
- `workshop-frontend`

---

## Local Development

### Backend

Path: `apps/backend/YoutubeLiveApp`

- .NET 8 project
- Health endpoint used by probes: `/backend/health`

### Frontend

Path: `apps/frontend/youtube-live-app`

- Next.js 14

---

## Useful Commands

From repository root:

- Check branch and status
  - `git branch --show-current`
  - `git status --short`

- Build backend image
  - `docker build -t workshop-backend:local ./apps/backend/YoutubeLiveApp`

- Build frontend image
  - `docker build -t workshop-frontend:local ./apps/frontend/youtube-live-app`

---

## Related Repositories

- App repo (this): `xavero-evandro/devops-workshop`
- GitOps repo: `xavero-evandro/devops-workshop-gitops`

---

## Notes

If you are testing locally with k3d and ArgoCD, the cluster can consume local images only if image names/tags match the manifest tags or images are imported with matching tags.
