variable gcp_project_id {
  type = string
}

variable vpc_network {
  type = string
}

variable vpc_subnetwork {
  type = string
}

variable vpc_subnetwork_cidr_range {
  type = string
}

variable primary_network_region {
  type = string
}

variable primary_network_zone {
  type = string
}

variable secondary_network_zone {
  type = string
}

variable cloudera_machine_type {
  type = string
}

variable cloudera_machine_image {
  type = string
}

variable cloudera_network_tag {
  type = string
}

variable cloudera_master_boot_disk_size_gb {
  type = string
}

variable cloudera_master_grid_disk_size_gb {
  type = string
}

variable cloudera_master_node_count {
  type = string
}

variable cloudera_worker_boot_disk_size_gb {
  type = string
}

variable cloudera_worker_grid_disk_size_gb {
  type = string
}

variable cloudera_worker_node_count {
  type = string
}

variable zaloni_machine_type {
  type = string
}

variable zaloni_machine_image {
  type = string
}

variable zaloni_network_tag {
  type = string
}

variable zaloni_boot_disk_size_gb {
  type = string
}

variable zaloni_opt_disk_size_gb {
  type = string
}
