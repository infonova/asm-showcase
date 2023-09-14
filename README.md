# asm-showcase
This is a showcase for demostrating Anthos Service Mesh and related Anthos features.

Terraform is used to deploy [general infrastructure](infra/main.tf) such as VPC, DNS records and the Kubernetes clusters (Autopilot mode).

There is a config cluster, which hosts a Multi-Cluster Ingress and [is configured using the fleet API with Terraform](infra/modules/config-cluster/fleet.tf)

There are two worker clusters, which run Anthos Service Mesh, also configured with [Terraform and the fleet API](infra/modules/worker-cluster/asm.tf)

Config Sync is used to deploy Kubernetes Manifests to the clusters. 
The Config Cluster is configured with [Terraform to use Config Sync ](infra/modules/config-cluster/acm.tf) to use the manifests [config-sync/config-cluster](config-sync/config-cluster) configured in this folder. 

The Worker Clusters are configured with [Terraform to use Config Sync and Policy Controller](infra/modules/worker-cluster/acm.tf) to use the manifests [config-sync/worker-cluster](config-sync/worker-cluster) configured in this folder. It contains an [Istio Ingressgateway](config-sync/worker-cluster/ingress-gateway.yaml), and also a [Gateway](config-sync/worker-cluster/gateway.yaml).

It also contains [Mesh Options](config-sync/worker-cluster/mesh-options.yaml), which can be specified in a declaratively.

Policies are applied, such as a [strict mTLS policy](config-sync/worker-cluster/mtls.yaml), which is an Istio feature, as well a sample Policy Controller (Gatekeeper) contraint to [require non-privileged pods](config-sync/worker-cluster/no-priviliged-pod-constraint.yaml).