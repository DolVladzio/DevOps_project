#!/bin/bash
# == Setup configmap ========================
kubectl apply -f app-config.yml
# == Setup services =========================
kubectl apply -f services/
# == Setup deployments ======================
kubectl apply -f deployments/
# == Wait for pods =======================
kubectl wait pods --all --for condition=Ready
