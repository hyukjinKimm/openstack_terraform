terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"  # 올바른 프로바이더 소스
      version = "~> 1.5"  # 원하는 버전 지정
    }
  }
}

resource "openstack_compute_instance_v2" "this" {
  name            = var.name
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = var.security_groups
  config_drive = true
//  network {
//   uuid = var.network_id
//  }
  network {
    port = var.port_id
  }
  user_data = var.user_data_path != "" ? templatefile(var.user_data_path, { hostname = var.hostname }) : null
  floating_ip = var.floating_ip != "" ? var.floating_ip : null
  timeouts {
    create = "30m"
  }
}

