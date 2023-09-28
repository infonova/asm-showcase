```shell
kubectl apply -f .\setup.yaml
```

## mTLS

Create Pod to run curl command. Disable sidecar injection
```shell
kubectl apply -f .\mtls\curl-pod-without-proxy.yaml
```

Execute curl command from inside pod - it works since Istio sidecar allows plaintext connections.
```shell
kubectl exec --stdin --tty curl-pod -n asm-usecase -- bash
```

```shell
curl http://secure-service
```

```shell
kubectl apply -f .\mtls\peer-authentication.yaml
```

```shell
kubectl apply -f .\mtls\curl-pod.yaml
```

## Service 2 Service Authorization

```shell
kubectl apply -f .\s2s-authz\authorization-policy.yaml
```

```shell
kubectl apply -f .\s2s-authz\curl-pod-with-sa.yaml
```

```shell
kubectl delete pod curl-pod -n asm-usecase
```





## Teardown
```shell
kubectl delete -f setup.yaml
```
