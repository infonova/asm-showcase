## Policies

### Enforce Istio best practices

Istio [recommends](https://istio.io/latest/docs/ops/best-practices/security/#use-allow-with-positive-matching-and-deny-with-negative-match-patterns) using `ALLOW-with-positive-matching` and `DENY-with-negative-match` patterns.
These authorization policy patterns are safer because the worst result in the case of policy mismatch is an unexpected 403 rejection instead of an authorization policy bypass.

```shell
kubectl apply -f .\policies\authz-policy-unsafe.yaml
```

```shell
kubectl delete -f .\policies\authz-policy-unsafe.yaml
```

The usage of these patterns can be enforced with Anthos Policy Controller (based on OPA). In this case via `AsmAuthzPolicySafePattern` custom resource.
Constraints can be configured to only apply to certain namespaces or resources.

```shell
kubectl apply -f .\policies\constraint-authz-safe-pattern.yaml
```

```shell
kubectl delete -f .\policies\constraint-authz-safe-pattern.yaml
```

After creating the constraint, the AuthorizationPolicy with unsafe pattern cannot be created.
Apply the safe pattern AuthorizationPolicy instead.

```shell
kubectl apply -f .\policies\authz-policy-safe.yaml
```


### Enforce Kubernetes security best practices

```shell
kubectl apply -f .\policies\privileged-pod.yaml
```

```shell
kubectl delete -f .\policies\privileged-pod.yaml
```

Restrict ability to create pods that run in [privileged mode](https://kubernetes.io/docs/concepts/workloads/pods/#privileged-mode-for-containers)
Only pods running in the kube-system namespace use privileged mode.

```shell
kubectl apply -f .\policies\constraint-no-priviliged-pod.yaml
```

```shell
kubectl delete -f .\policies\constraint-no-priviliged-pod.yaml
```
