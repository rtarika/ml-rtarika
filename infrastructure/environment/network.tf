resource google_compute_network vpc_network_ml_rtarika {
  name                    = var.vpc_network
  project                 = var.gcp_project_id
  description             = "Thi's VPC"
  auto_create_subnetworks = false
}

resource google_compute_subnetwork subnet_ml_rtarika {
  name          = var.vpc_subnetwork
  project       = var.gcp_project_id
  description   = "Thi's VPC Subnet"
  network       = google_compute_network.vpc_network_ml_rtarika.self_link
  ip_cidr_range = var.vpc_subnetwork_cidr_range
  region        = var.primary_network_region
}

resource google_compute_router net-router {
  name    = "net-router"
  region  = var.primary_network_region
  network = google_compute_network.vpc_network_ml_rtarika.self_link
}

resource google_compute_router_nat nat {
  name                               = "net-router-nat"
  router                             = google_compute_router.net-router.name
  region                             = google_compute_router.net-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
