resource "google_compute_instance_template" "zaloni_edge_template" {
  name_prefix = "zaloni-edge-template"
  description = "Zaloni Edge VM template"

  tags = [var.zaloni_network_tag]

  labels = {
    terraformed = "true"
  }

  machine_type = var.zaloni_machine_type

  disk {
    source_image = var.zaloni_machine_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = var.zaloni_boot_disk_size_gb
  }

  disk {
    auto_delete  = true
    boot         = false
    disk_type    = "pd-ssd"
    disk_size_gb = var.zaloni_opt_disk_size_gb 

  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_ml_rtarika.self_link
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
    mkdir -p /grid
    mount -o discard,defaults /dev/sdb /opt

    EOF
}

resource "google_compute_instance_from_template" "zaloni_edge" {
  name = "zaloni-edge"
  zone = var.primary_network_zone

  source_instance_template = google_compute_instance_template.zaloni_edge_template.self_link
}
