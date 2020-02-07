resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  description   = "Allow ssh from internal hosts to bastion"
  network       = google_compute_network.vpc_network_ml_rtarika.self_link
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = [
    var.cloudera_network_tag,
    var.zaloni_network_tag
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_egress_all" {
  name        = "allow-egress-tcp"
  description = "Allow egress"
  network     = google_compute_network.vpc_network_ml_rtarika.self_link
  direction   = "EGRESS"
  target_tags = [
    var.cloudera_network_tag
  ]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

