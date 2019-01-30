variable "base_configuration" {
  description = "use ${module.base.configuration}, see the main.tf example file"
  type = "map"
}

variable "name" {
  description = "hostname, without the domain part"
  type = "string"
}

variable "use_released_updates" {
  description = "Apply all updates from SUSE Linux Enterprise repos"
  default = false
}

variable "use_unreleased_updates" {
  description = "Apply all updates from SUSE Linux Enterprise unreleased (Test) repos"
  default = false
}

variable "additional_repos" {
  description = "extra repositories in the form {label = url}, see README_ADVANCED.md"
  default = {}
}

variable "additional_packages" {
  description = "extra packages to install, see README_ADVANCED.md"
  default = []
}

variable "count"  {
  description = "number of hosts like this one"
  default = 1
}

variable "grains" {
  description = "custom grain string to be added to this host's configuration"
  default = ""
}

variable "ssh_key_path" {
  description = "path of additional pub ssh key you want to use to access VMs, see README_ADVANCED.md"
  default = "/dev/null"
  # HACK: "" cannot be used as a default because of https://github.com/hashicorp/hil/issues/50
}

variable "gpg_keys" {
  description = "salt/ relative paths of gpg keys that you want to add to your VMs, see README_ADVANCED.md"
  default = []
}

variable "connect_to_base_network" {
  description = "true if you want a card connected to the main network, see README_ADVANCED.md"
  default = true
}

variable "connect_to_additional_network" {
  description = "true if you want a card connected to the additional network (if any), see README_ADVANCED.md"
  default = false
}

// Provider-specific variables

variable "image" {
  description = "One of: opensuse423, opensuse150, sles11sp4, sles12, sles12sp1, sles12sp2, sles12sp3, sles15, centos7"
  type = "string"
}

variable "memory" {
  description = "RAM memory in MiB"
  default = 512
}

variable "vcpu" {
  description = "number of virtual CPUs"
  default = 1
}

variable "running" {
  description = "whether this host should be turned on or off"
  default = true
}

variable "mac" {
  description = "a MAC address in the form AA:BB:CC:11:22:22"
  default = ""
}

variable "additional_disk" {
  description = "disk block definition(s) to be added to this host"
  default = []
}
