# Parcial II - Kubernetes (Minikube + Floci)

Infraestructuras Paralelas y Distribuidas (750023C). API FastAPI + PostgreSQL desplegada en Minikube, más IAM/S3/EKS contra Floci.

- `api/`: API (`/health`, `/items`) y Dockerfile.
- `k8s/`: manifiestos. Copie `01-secret.example.yaml` a `01-secret.yaml` y cambie la contraseña antes de aplicar.
- `floci/`: docker-compose de Floci.
- `capturas/`: evidencias.

Despliegue: `docker build -t parcial2-api:1.0 api && minikube image load parcial2-api:1.0 && kubectl apply -f k8s/`
