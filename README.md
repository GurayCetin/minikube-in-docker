# Minikube with Docker and ShinyProxy

This project sets up a Minikube cluster using Docker as the driver and deploys a ShinyProxy application. The configuration is designed for Kubernetes `v1.25.9` and uses `arm64` architecture.

---

## Prerequisites

Ensure the following are installed on your system:
- Docker Daemon (with `docker-compose`)
- A system supporting `arm64` architecture (or Docker's multi-architecture support)

---

## Project Structure

- **`Dockerfile`**: Builds a container with Minikube, Kubernetes tools, and dependencies.
- **`docker-compose.yaml`**: Defines services for `socat` and `minikube`.
- **`entrypoint.sh`**: Script to start Minikube and deploy the ShinyProxy application.
- **`shinyproxy/kustomize/base`**: Base Kubernetes manifests for ShinyProxy.
- **`shinyproxy/kustomize/overlays`**: Environment-specific configurations for ShinyProxy.
- **`.env`**: Environment variables for Docker Compose.

---

## Why is `socat` Used?

`socat` is used to expose the Docker socket (`/var/run/docker.sock`) over TCP (`tcp://localhost:2375`). This allows the `minikube` service to communicate with the Docker daemon running on the host system. Without `socat`, Minikube would not be able to create and manage Kubernetes containers.

---

## Setup Instructions
Build the Docker Image
Build the Docker image for Minikube and ShinyProxy:
```bash
docker-compose up --build -d
```