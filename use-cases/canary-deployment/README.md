## Setup

```shell
kubectl apply -f .\argo-rollouts\service.yaml
kubectl apply -f .\argo-rollouts\virtual-service.yaml
kubectl apply -f .\argo-rollouts\destination-rule.yaml
kubectl apply -f .\argo-rollouts\rollout-analysis.yaml
kubectl apply -f .\argo-rollouts\rollout.yaml
```

Check if pod was created and Rollout is up and running
```shell
kubectl get pods -n asm-usecase
```

```shell
kubectl argo rollouts get rollout greet-service -n asm-usecase --watch
```

## Start load generator
```shell
k6 run one-rps.js
```

## Deploy new v2
```shell
kubectl apply -f .\argo-rollouts\rollout-v2.yaml
```

## Deploy new v2
```shell
kubectl apply -f .\argo-rollouts\rollout-v3.yaml
```

## Teardown

```shell
kubectl delete -f .\argo-rollouts\
```
