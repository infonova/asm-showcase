variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in"
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
