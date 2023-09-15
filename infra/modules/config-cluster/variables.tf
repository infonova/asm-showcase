

variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "acm_feature" {

}