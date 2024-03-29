# asm-showcase
This is a showcase for demostrating Anthos Service Mesh and related Anthos features.

Terraform is used to deploy [general infrastructure](infra/main.tf) such as VPC, DNS records, a static IP, and a Google managed certificate and the Kubernetes clusters.

There is a config cluster, which hosts a Multi-Cluster Ingress (MCI) and [is configured using the fleet API with Terraform](infra/modules/config-cluster/fleet.tf). For this demo, a google managed certificate and an static IP are referenced in the [MCI declaration](config-sync/config-cluster/multi-cluster-ingress.yaml).

There are two worker clusters, which run Anthos Service Mesh, also configured with [Terraform and the fleet API](infra/modules/worker-cluster/asm.tf).

The config Cluster uses Autopilot mode, and the worker clusters use Standard mode. The reason for using Standard mode is the slow scale-up for Autopilot cluster, which is not suitable for a demo, which involves creating and destroying infrastructure frequently. It can take more then half an hour for all workloads to get deployed (after the Terraform run, which itself can take 10 minutes).

Config Sync is used to deploy Kubernetes Manifests to the clusters. 
The Config Cluster is configured with [Terraform to use Config Sync ](infra/modules/config-cluster/acm.tf) to use the manifests [config-sync/config-cluster](config-sync/config-cluster) configured in this folder. 

The Worker Clusters are configured with [Terraform to use Config Sync and Policy Controller](infra/modules/worker-cluster/acm.tf) to use the manifests [config-sync/worker-cluster](config-sync/worker-cluster) configured in this folder. It contains an [Istio Ingressgateway](config-sync/worker-cluster/ingress-gateway.yaml), and also a [Gateway](config-sync/worker-cluster/gateway.yaml).

It also contains [Mesh Options](config-sync/worker-cluster/mesh-options.yaml), which can be specified in a declaratively.

Policies are applied, such as a [strict mTLS policy](config-sync/worker-cluster/mtls.yaml), which is an Istio feature, as well a sample Policy Controller (Gatekeeper) contraint to [require non-privileged pods](config-sync/worker-cluster/no-priviliged-pod-constraint.yaml).

For simplicity and convenience, a  [demo application](config-sync/worker-cluster/online-boutique.yaml) is also deployed using Config Sync (though this would typically be done with a CD tool such as Argo) which is available at https://anthos.gcp-demo.be-svc.at.

# How to run it

First, make sure, you are running in the be GCP project and you have permission to run it, e.g. by using <pre>gcloud auth application-default login</pre>

Then run Terraform. This setups everything.
<pre>cd infra
terraform init
terraform apply
</pre>

# Destroying it

<pre>terraform destroy</pre>

Limitations: When running that command, some resource may have to be cleaned up manually. This is relevant for the config cluster, as an existing MCI blocks destruction of the membership. Using this commands they can be deleted. Make sure that Config Sync is actually disabled, otherwise the MCI will be recreated.

<pre>
gcloud container clusters get-credentials gke-config-cluster --region europe-west1 --project asm-showcase-6312a455
kubectl delete mci  --namespace asm-showcase anthos-ingress-gateway
kubectl delete mcs  --namespace asm-showcase anthos-ingress-service
</pre>