# DevOps Example: Jenkins Pipeline with Docker & Minikube

This repository contains an **exercise** demonstrating a complete CI/CD workflow:

- **Jenkinsfile** that clones the code on a build server, builds a Docker image, uploads it to DockerHub, and then deploys the application as a Pod on a separate deploy server (Minikube).
- **GitHub Actions** (Sonar Cloud & Snyk) run automatically on every push to the `development` branch, ensuring code quality and security checks.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Key Components](#key-components)
- [Workflow Stages](#workflow-stages)
- [Prerequisites](#prerequisites)
- [How It Works](#how-it-works)
- [Reference](#reference)
- [License](#license)

---

## Architecture Overview

┌───────────────┐ Docker image ┌───────────────┐ │ Build Server │ ──────────────────────> │ Docker Hub │ │ (Ubuntu 24.04) │ └───────────────┘ │ Docker Engine │ └───────────────┘ | | Jenkins pipeline triggers v ┌────────────────┐ │ Deploy Server │ │ (Ubuntu 24.04) │ │ Minikube │ └────────────────┘ | HTTPS (443) v ┌─────────────┐ │ Internet │ └─────────────┘
