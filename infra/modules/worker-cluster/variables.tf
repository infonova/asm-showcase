

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

variable "cl_index" {
  type = string
} 

variable "asm_feature" {
  
}

variable "acm_feature" {
  
}