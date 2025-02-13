terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.5"
    }
  }
}

provider "openstack" {
  auth_url         = var.openstack_auth_url
  user_name        = var.openstack_user_name
  password         = var.openstack_password
  tenant_id        = var.openstack_tenant_id
  tenant_name      = var.openstack_tenant_name
  user_domain_name = var.openstack_user_domain_name
  region           = var.openstack_region
  insecure         = var.openstack_insecure
}
data "openstack_networking_network_v2" "demo-net" {
  name = "demo-net"
}
data "openstack_networking_subnet_v2" "demo-subnet" {
  network_id = data.openstack_networking_network_v2.demo-net.id
}
data "openstack_compute_flavor_v2" "k8s_m" {
  name = "k8s.m"
}
data "openstack_compute_flavor_v2" "k8s_w" {
  name = "k8s.w"
}
data "openstack_compute_flavor_v2" "k8s_lb" {
  name = "k8s.lb"
}
data "openstack_compute_flavor_v2" "db" {
  name = "db"
}
data "openstack_compute_flavor_v2" "stg" {
  name = "stg"
}
data "openstack_compute_flavor_v2" "bastion" {
  name = "m1.tiny"
}
# 보안 그룹
module "security_group" {
  source = "./modules/security_group"
}
data "openstack_networking_floatingip_v2" "existing_fip" {
  address = "10.10.10.197"  
}

# 포트 모듈 정의
module "k8s-master1-internal-port" {
  source      = "./modules/port"
  name        = "k8s-master1-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.101"
}

module "k8s-master2-internal-port" {
  source      = "./modules/port"
  name        = "k8s-master2-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.102"
}
module "k8s-master3-internal-port" {
  source      = "./modules/port"
  name        = "k8s-master3-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.103"
}
module "k8s-worker1-internal-port" {
  source      = "./modules/port"
  name        = "k8s-worker1-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.104"
}
module "k8s-worker2-internal-port" {
  source      = "./modules/port"
  name        = "k8s-worker2-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.105"
}
module "k8s-storage-internal-port" {
  source      = "./modules/port"
  name        = "k8s-storage-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.110"
}
module "k8s-db1-internal-port" {
  source      = "./modules/port"
  name        = "k8s-db1-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.108"
}
module "k8s-db2-internal-port" {
  source      = "./modules/port"
  name        = "k8s-db2-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.109"
}
module "k8s-bootstrap-internal-port" {
  source      = "./modules/port"
  name        = "k8s-bootstrap-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.111"
}
module "k8s-bastion-internal-port" {
  source      = "./modules/port"
  name        = "k8s-bastion-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.120"

}
module "k8s-lb1-internal-port" {
  source      = "./modules/port"
  name        = "k8s-lb1-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.106"

  allowed_address_ip = "192.168.100.150"
}
module "k8s-lb2-internal-port" {
  source      = "./modules/port"
  name        = "k8s-lb2-internal-port"
  network_id  = data.openstack_networking_network_v2.demo-net.id
  security_group_ids = [module.security_group.security_group_id]
  subnet_id   = data.openstack_networking_subnet_v2.demo-subnet.id
  ip_address  = "192.168.100.107"

  allowed_address_ip = "192.168.100.150"
}

# 인스턴스 모듈 정의
module "bootstrap" {
  source      = "./modules/instance"
  name        = "bootstrap"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.db.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-bootstrap-internal-port.port_id

  hostname    = "bootstrap"
  user_data_path = "./scripts/ansible_server_data.tpl"
}

module "master1" {
  source      = "./modules/instance"
  name        = "master1"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_m.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-master1-internal-port.port_id

  hostname    = "controller1.example.com"
  user_data_path = "./scripts/init.tpl"
}

module "master2" {
  source      = "./modules/instance"
  name        = "master2"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_m.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-master2-internal-port.port_id

  hostname    = "controller2.example.com"
  user_data_path = "./scripts/init.tpl"
}
module "master3" {
  source      = "./modules/instance"
  name        = "master3"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_m.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-master3-internal-port.port_id

  hostname    = "controller3.example.com"
  user_data_path = "./scripts/init.tpl"
}

module "worker1" {
  source      = "./modules/instance"
  name        = "worker1"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_w.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-worker1-internal-port.port_id

  hostname    = "worker1.example.com"
  user_data_path = "./scripts/init.tpl"
}
module "worker2" {
  source      = "./modules/instance"
  name        = "worker2"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_m.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-worker2-internal-port.port_id

  hostname    = "worker2.example.com"
  user_data_path = "./scripts/init.tpl"
}

module "lb1" {
  source      = "./modules/instance"
  name        = "lb1"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_lb.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-lb1-internal-port.port_id

  hostname    = "lb1"
  user_data_path = "./scripts/init.tpl"
}

module "lb2" {
  source      = "./modules/instance"
  name        = "lb2"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_lb.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-lb2-internal-port.port_id

  hostname    = "lb2"
  user_data_path = "./scripts/init.tpl"
}

module "storage" {
  source      = "./modules/instance"
  name        = "storage"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.stg.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-storage-internal-port.port_id

  hostname    = "storage.example.com"
  user_data_path = "./scripts/init.tpl"
}
module "db1" {
  source      = "./modules/instance"
  name        = "db1"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.db.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-db1-internal-port.port_id

  hostname    = "db1.example.com"
  user_data_path = "./scripts/init.tpl"
}
module "db2" {
  source      = "./modules/instance"
  name        = "db2"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.db.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-db2-internal-port.port_id

  hostname    = "db2.example.com"
  user_data_path = "./scripts/init.tpl"
}
module "bastion" {
  source      = "./modules/instance"
  name        = "bastion"
  image_id    = "2060ac71-3390-462f-b358-6abba12e56ae"
  flavor_id   = data.openstack_compute_flavor_v2.k8s_lb.id
  key_pair    = "mykey"
  security_groups = [module.security_group.security_group_id]
  port_id     = module.k8s-bastion-internal-port.port_id

  hostname    = "bastion"
  user_data_path = "./scripts/init.tpl"

}
resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = data.openstack_networking_floatingip_v2.existing_fip.address
  instance_id = module.bastion.instance_id
}



