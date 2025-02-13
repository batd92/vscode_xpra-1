# Project struct
```
root/
│── docker-compose.yml
│── traefik/
│   ├── traefik.yml
│   ├── dynamic_conf.yml
│── vscode/
│   ├── Dockerfile
│   ├── config/
│   │   ├── settings.json
│   │   ├── extensions.json
│   ├── workspace/
│── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│── .env
```

#  Docker Compose

Run: ```docker-compose up -d```

# Kubernetes

Run: ```kubectl apply -f k8s/```
Check status: ```kubectl get pods,svc,ingress```
