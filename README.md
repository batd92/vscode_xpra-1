Run VS Code on any machine anywhere and access it in the browser.
## Project struct
```
root/
│── docker-compose.yml
│── traefik/
│   ├── traefik.yml
│   ├── dynamic_conf.yml
│── vscode/
│   ├── Dockerfile
│   ├── bin/
│   │   ├── entrypoint.sh
│   ├── workspace/
│── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── pvc.yaml
│   ├── config.yaml
│   ├── ingress.yaml
│── .env
```

##  Docker Compose

Run: ```docker-compose up -d```

## Kubernetes

### Run with Localhost:

1. Build image ```docker build -t my-vscode-image -f vscode/Dockerfile .```
2. Load image into Kubernetes ```docker tag my-vscode-image my-vscode-image:latest```
3. Run: ```kubectl apply -f k8s/```
4. Check status:```kubectl get pods,svc,ingress```
