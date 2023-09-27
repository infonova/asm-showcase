## Base Setup
Create two versions of a deployment (different response bodies), a service, a VirtualService and a DestinationRule.
The following use cases will configure the base VirtualService.

```shell
kubectl apply -f .\base\
```

## JWT Based Routing
```shell
kubectl apply -f .\jwt-based-routing\
```

```shell
kubectl delete -f .\jwt-based-routing\request-authentication.yaml
```


## Traffic Mirroring
```shell
kubectl apply -f .\mirror\
```

Follow logs of v2 deployment to show requests
```shell
kubectl logs deployment/hello-service-v2 -n asm-usecase --follow
```


## Fault Injection
```shell
kubectl apply -f .\fault-injection\
```

## Teardown Base Setup
```shell
kubectl delete -f .\base\
```
