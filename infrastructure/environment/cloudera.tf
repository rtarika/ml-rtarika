resource "google_compute_instance_template" "cloudera_master_template" {
  name_prefix = "master-node-template"
  description = "Master node server template"

  tags = [var.cloudera_network_tag]

  labels = {
    terraformed = "true"
  }

  machine_type = var.cloudera_machine_type

  disk {
    source_image = var.cloudera_machine_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = var.cloudera_master_boot_disk_size_gb
  }

  disk {
    auto_delete  = true
    boot         = false
    disk_type    = "pd-ssd"
    disk_size_gb = var.cloudera_master_grid_disk_size_gb 

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
    mount -o discard,defaults /dev/sdb /grid

    EOF
}

resource "google_compute_instance_template" "cloudera_worker_template" {
  name_prefix = "cloudera-worker-template"
  description = "Cloudera worker template"

  tags = [var.cloudera_network_tag]

  labels = {
    terraformed = "true"
  }

  machine_type = var.cloudera_machine_type

  disk {
    source_image = var.cloudera_machine_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = var.cloudera_worker_boot_disk_size_gb
  }

  disk {
    auto_delete  = true
    boot         = false
    disk_type    = "pd-ssd"
    disk_size_gb = var.cloudera_worker_grid_disk_size_gb

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
    mount -o discard,defaults /dev/sdb /grid

    EOF
}

resource "google_compute_region_instance_group_manager" "cloudera_master_group_manager" {
  name               = "cloudera-master-igm"
  base_instance_name = "cloudera-master"
  region             = var.primary_network_region
  target_size        = var.cloudera_master_node_count

  version {
    instance_template  = google_compute_instance_template.cloudera_master_template.self_link
  }

  distribution_policy_zones = [
    var.primary_network_zone
  ]
}

resource "google_compute_region_instance_group_manager" "cloudera_worker_group_manager" {
  name               = "cloudera-worker-igm"
  base_instance_name = "cloudera-worker"
  region             = var.primary_network_region
  target_size        = var.cloudera_worker_node_count

  version {
    instance_template  = google_compute_instance_template.cloudera_worker_template.self_link
  }

  distribution_policy_zones = [
    var.primary_network_zone
  ]
}
