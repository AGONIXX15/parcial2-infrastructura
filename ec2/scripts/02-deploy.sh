#!/usr/bin/env bash
# Despliegue de la Fase 1 (con extras PVC + Ingress). Ejecutar desde la carpeta ec2/.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f k8s/01-secret.yaml ] || { echo "Falta k8s/01-secret.yaml (copia el .example y cambia la clave)"; exit 1; }
minikube status >/dev/null 2>&1 || minikube start --driver=docker --cpus=2 --memory=3072
minikube addons enable ingress
docker build -t parcial2-api:1.0 api
minikube image load parcial2-api:1.0
kubectl apply -f k8s/00-namespace.yaml -f k8s/01-secret.yaml
kubectl apply -f k8s/02-db.yaml -f k8s/03-api.yaml
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s
kubectl apply -f k8s/04-ingress.yaml
kubectl -n parcial2-app rollout status deploy/db deploy/api --timeout=180s || kubectl -n parcial2-app rollout status deploy/api --timeout=180s
kubectl get pods,svc,pvc,ingress -n parcial2-app
echo "LoadBalancer: en otra terminal 'minikube tunnel', luego curl http://<EXTERNAL-IP>/health"
echo "Ingress:      curl -H 'Host: api.parcial2.local' http://\$(minikube ip)/health"
