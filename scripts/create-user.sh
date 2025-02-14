#!/bin/bash

# Usage: ./create-user.sh <username>
USERNAME=$1
NAMESPACE=$USERNAME

# Create namespace
kubectl create namespace $NAMESPACE

# Create PersistentVolumeClaim
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: code-server-pvc
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

# Create Code-Server Deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vm-vscode
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: code-server
  template:
    metadata:
      labels:
        app: code-server
    spec:
      containers:
      - name: code-server
        image: codercom/code-server:latest
        ports:
        - containerPort: 8080
        volumeMounts:
        - mountPath: /home/coder/project
          name: code-server-data
      volumes:
      - name: code-server-data
        persistentVolumeClaim:
          claimName: code-server-pvc
EOF

# Create Service
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: code-server-service
  namespace: $NAMESPACE
spec:
  selector:
    app: code-server
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
EOF

# Create Ingress
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: code-server-ingress
  namespace: $NAMESPACE
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
spec:
  rules:
  - host: vscode.localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: code-server-service
            port:
              number: 80
EOF

echo "User $USERNAME has been created with namespace $NAMESPACE"