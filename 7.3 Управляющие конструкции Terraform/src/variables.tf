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
  description = "VPC network&subnet name"
}

# переменные для создания ВМ web, тз 2.1

variable "vm_web_ubuntu_image" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "count_web" {
  description = "количество создаваемых одинаковых виртуальных машин"
  type        = number
  default     = 2
}

variable "vm_name_platform" {
  type        = string
  default     = "web"
  description = "web platform name"
}

variable "vm_web_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_resources" {
  type = map(any)
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
  }
}
#---

# ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb4ssWoeHjVHZPP/8Qomg+A+XewJuMsTTRakRzYvVTApKALpY0ktn1YOQG6/ff5oH8Jt14/NMLWl+O96L8DkNmdafyl0bYQvk5fxtz3hfCYOYEu4RhvkkQB29X3cEXJAq1PTo5AqgVrFoz76DzuKZYzRvbpPRK8koOm9MsYuQDEwAHpoU2Q7gG47Ede/UOi0uYLm0/frbOEjH9MPdnl+Ut84is3U+NQFAkIQTudy+w9nNNtyF9B+kUaOzn6E4GpEVHVVDjJLfhhMCQj+BTMtZ1WTkVqvg9K6+kY8eUuCPPfaVOcsVIhoOsavNGC50Zm0XFalpPs3Hkq9PpmXod80+u9gxRkFBWA0XSlckUk9ZZe5apzxRSuILOCC/x/G6gLAY1iF96bsicRqxaMS4SfX3lYt9CDXTdot62zEGnc42ST0WmsUbuf5skPLSEWNC4UZ2IGEhQfmvYyALMwPLpSoQYCIffDk62HLmt0+bf1L77dfcU7lba8IXLUj3rv+iHLyU= pubman@macbookpro.local"
  description = "ssh-keygen -t ed25519"
}

# создаем main и replica, задание 2.2

variable "vm_instances" {
  type = map(object({
    vm_name       = string
    cpu           = number
    ram           = number
    core_fraction = number
  }))
  default = {
    main = {
      vm_name       = "main"
      cpu           = 2
      ram           = 1
      core_fraction = 5
    }
    replica = {
      vm_name       = "replica"
      cpu           = 2
      ram           = 1
      core_fraction = 5
    }
  }
}

#---
