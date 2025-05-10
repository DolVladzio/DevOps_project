#!/bin/bash
# == Setup configmap ========================
kubectl apply -f app-config.yml
# == Setup services =========================
kubectl apply -f services/
# == Setup redis && postgres deployments ====
kubectl apply -f deployments/redis-deployment.yml && kubectl apply -f deployments/postgres-deployment.yml
# == Wait for pods =======================
kubectl wait pods --all --for condition=Ready
# == Setup frontend && backend deployments ==
kubectl apply -f deployments/backend-deployment.yml && kubectl apply -f deployments/frontend-deployment.yml

