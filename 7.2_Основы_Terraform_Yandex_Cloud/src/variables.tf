###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb4ssWoeHjVHZP....."
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_ubuntu_image" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_develop_platform" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_resources" {
  type = map(map(any))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }

}

variable "metadata_for_all" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb4ssWoeHjVHZPP/8Qomg+A+XewJuMsTTRakRzYvVTApKALpY0ktn1YOQG6/ff5oH8...."

  }
}
