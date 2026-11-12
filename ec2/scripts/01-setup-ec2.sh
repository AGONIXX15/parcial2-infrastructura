#!/usr/bin/env bash
# Preparar una EC2 Ubuntu: docker, kubectl, minikube. Ejecutar como usuario normal (no root).
set -euo pipefail
sudo apt-get update -y && sudo apt-get install -y --fix-missing docker.io curl git
sudo usermod -aG docker "$USER"
curl -fsSLo /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install /tmp/minikube /usr/local/bin/minikube
curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install /tmp/kubectl /usr/local/bin/kubectl
echo "Cierra sesion y vuelve a entrar (grupo docker), luego: ./02-deploy.sh"
