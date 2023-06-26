variable "name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "hostname" {
  type = string
  default = ""
}

variable "description" {
  type = string
  default = ""
}

variable "zone" {
  default = "a"
}

variable "metadata" {
  default = {}
}

variable "cores" {
  default = 2
}

variable "memory" {
  default = 2
}

variable "fraction" {
  default = 20
}

variable "platform" {
  default = 3
}

variable "allow_stopping_for_update" {
  default = true
}

variable "preemptible" {
  default = false
}

variable "boot_disk_image_id" {
  type = string
  default = ""
}

variable "boot_disk_family_id" {
  type = string
  default = "ubuntu-2204-lts"
}

variable "boot_disk_name" {
  default = ""
}

variable "boot_disk_size" {
  default = 15
}

variable "boot_disk_type" {
  default = "network-ssd"
}

variable "boot_disk_snapshot_id" {
  type = string
  default = ""
}

variable "security_groups" {
  default = []
}

variable "nat_ip_address" {
  default = ""
}

variable "extra_disks" {
  default = {}
  # {
  #   disk1 = { type = "network-hdd", size = "15", auto_delete = true, device_name = "/mnt/disk1", mode = "READ_WRITE" }
  # }
}

