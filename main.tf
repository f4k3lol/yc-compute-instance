locals {
  security_groups = try(toset(jsondecode(var.security_groups)), toset(var.security_groups))
  extra_disks = try(jsondecode(var.extra_disks), var.extra_disks)
  metadata = try(jsondecode(var.metadata), var.metadata)
}

resource "yandex_compute_disk" "extra_disk" {
  for_each = local.extra_disks
  name     = "${var.name}-${each.key}"
  size     = each.value.size
  type     = each.value.type
  zone     = var.zone
}

data "yandex_compute_image" "image" {
  family = var.boot_disk_family_id
}

data "yandex_vpc_security_group" "sg" {
  for_each = local.security_groups
  name = each.key
}

locals {
  security_group_ids = [ for sg in data.yandex_vpc_security_group.sg : sg.id ]
}

resource "yandex_compute_instance" "vm" {
  name                      = var.name
  platform_id               = "standard-v${var.platform}"
  zone                      = "ru-central1-${var.zone}"
  allow_stopping_for_update = var.allow_stopping_for_update
  hostname                  = var.hostname != "" ? var.hostname : var.name
  description               = var.description

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.fraction
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      name        = var.boot_disk_name != "" ? var.boot_disk_name : "${var.name}-boot"
      size        = var.boot_disk_size
      type        = var.boot_disk_type
      #если указан snapshot_id - null, если не указан image_id - используется id из family
      image_id    = var.boot_disk_snapshot_id != "" ? null : (var.boot_disk_image_id != "" ? var.boot_disk_image_id : data.yandex_compute_image.image.id)
      snapshot_id = var.boot_disk_snapshot_id
    }
  }

  #присоединяем диски если есть переменная extra_disk_type
  dynamic "secondary_disk" {
    for_each = local.extra_disks
    content {
      disk_id = yandex_compute_disk.extra_disk[secondary_disk.key].id
      auto_delete = lookup(secondary_disk.value, "auto_delete", null)
      device_name = lookup(secondary_disk.value, "device_name", null)
      mode = lookup(secondary_disk.value, "mode", null)
    }
  }

  network_interface {
    nat                = var.nat_ip_address != ""
    nat_ip_address     = var.nat_ip_address != "" ? var.nat_ip_address : null
    subnet_id          = var.subnet_id
    security_group_ids = local.security_group_ids
  }

  metadata = local.metadata
}