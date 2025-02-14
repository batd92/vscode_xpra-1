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

Run: ```kubectl apply -f k8s/```
Check status: ```kubectl get pods,svc,ingress```
