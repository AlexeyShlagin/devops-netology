# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»


### Задание 1

#### 1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
`выполнено`

#### 2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
`выполнено`

#### 3. Сгенерируйте или используйте свой текущий ssh-ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
`выполнено`

#### 4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
```
Error: Error while requesting API to create instance: server-request-id = dd94d735-1110-4f4e-b7e7-aeb4c04fe9cc server-trace-id = 4d62206003330ca0:83479be8719b2e11:4d62206003330ca0:1 client-request-id = 44c958d1-512d-4b53-b77c-7deb1602365e client-trace-id = 91e06895-430e-4b68-a1b2-b8623ede824b rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
```
Платформы `standart-v4` на yandex cloud не существует, меняем на `standard-v1`

```
 Error: Error while requesting API to create instance: server-request-id = 7c9dd1c6-b099-4ae8-b22b-7e815784b8d7 server-trace-id = 1edfa78de4b8483:c686cb1415e66a5d:1edfa78de4b8483:1 client-request-id = 672fef26-63c1-43c9-bd70-1a551a72a469 client-trace-id = 16da9266-c74a-460c-9e25-1630e1f46032 rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v2"; allowed core number: 2, 4
 ```
нельзя использовать одно ядро, можно или 2 или 4. Используем 2, `cores = 2`


#### 5. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ. Ответ в документации Yandex Cloud.

`preemptible = true`
Этот параметр указывает, что виртуальная машина будет создана как "preemptible", или "временная". Виртуальные машины типа "preemptible" могут быть выгодными с точки зрения стоимости, так как они стоят дешевле, чем обычные ВМ и могут быть прерваны если прошло 24 часа или нужны ресурсы для другой, обычной виртуальной машины.
Удобство - забыл удалить ресурсы, - через 24 часа они сами удалились.

`core_fraction=5`
Задавая core_fraction=5, резервируется 5% ядер физической машины для вашей ВМ. Например если есть 20 ядер на физической машине, и мы устанавливаем core_fraction=5 для ВМ, то она будет иметь доступ к 1 ядру (5% от 20 ядер).

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ;
 ![](src/img/1.png)
 
- скриншот успешного подключения к консоли ВМ через ssh. К OS ubuntu необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address";
![](src/img/2.png)

### Задание 2

#### 1. Изучите файлы проекта.
`выполнено`

#### 2. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.

Заменяем:

```bash
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_ubuntu_image
}

resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_develop_platform
  platform_id = var.vm_web_platform_id
  ```


#### 2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 

  ```bash
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
```

#### 3. Проверьте terraform plan. Изменений быть не должно. 

```bash
➜  src git:(main) ✗ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpg2retpc18g5eifbml]
data.yandex_compute_image.ubuntu: Read complete after 3s [id=fd81n0sfjm6d5nq6l05g]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bkg3gga2dm0fhv08it]
yandex_compute_instance.platform: Refreshing state... [id=fhmbrjcnt19t9n80kqb0]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

### Задание 3

#### 1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
```bash
  src git:(main) ✗ cp variables.tf vms_platform.tf
  ```

#### 2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').

```bash
resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_develop_platform
  platform_id = var.vm_db_platform_id
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

#### 3. Примените изменения.

Получаем ошибку `Error: Duplicate variable declaration`
после этого удаляем все задублированные переменные в файле `vms_platform.tf`, после чего файл приобритает вид:
```bash
variable "vm_db_develop_platform" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type    = string
  default = "standard-v1"
}
```

```bash
terraform apply
```

### Задание 4

#### 1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
```bash
output "instance_external_ips" {
  description = "Словарь с соответствием имени экземпляра и его внешнего IP-адреса"
  value = {
    "netology-develop-platform"    = yandex_compute_instance.platform.network_interface[0].nat_ip_address,
    "netology-develop-platform-db" = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
  }
}
```

#### 2. Примените изменения.
```bash
terraform apply
```

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.
```bash
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

instance_external_ips = {
  "netology-develop-platform" = "158.160.117.172"
  "netology-develop-platform-db" = "158.160.35.255"
}
➜  src git:(main) ✗ 
```

### Задание 5

#### 1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.

```bash
locals {
  vm_name_platform = "${var.vm_web_ubuntu_image}-develop-platform"
  vm_name_db       = "${var.vm_web_ubuntu_image}-develop-platform-db"
}
```

#### 2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.
```bash
resource "yandex_compute_instance" "platform" {
  name        = local.vm_name_platform
  ```

```bash
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_name_db
  ```

#### 3. Примените изменения.

```bash
Terraform will perform the following actions:

  # yandex_compute_instance.platform will be updated in-place
  ~ resource "yandex_compute_instance" "platform" {
        id                        = "fhmbrjcnt19t9n80kqb0"
      ~ name                      = "netology-develop-platform-web" -> "ubuntu-2004-lts-develop-platform"
        # (9 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }

  # yandex_compute_instance.platform_db will be updated in-place
  ~ resource "yandex_compute_instance" "platform_db" {
        id                        = "fhmr7shk5m99s0jh4u4d"
      ~ name                      = "netology-develop-platform-db" -> "ubuntu-2004-lts-develop-platform-db"
        # (9 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }
```

### Задание 6

#### 1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную **vms_resources** и уже внутри неё конфиги обеих ВМ — вложенный map.

```bash
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
```

```bash
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_name_db
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_resources["db"]["cores"]
    memory        = var.vm_resources["db"]["memory"]
    core_fraction = var.vm_resources["db"]["core_fraction"]
  }
  ```

```bash
resource "yandex_compute_instance" "platform" {
  name        = local.vm_name_platform
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_resources["web"]["cores"]
    memory        = var.vm_resources["web"]["memory"]
    core_fraction = var.vm_resources["web"]["core_fraction"]
  }
  ```


#### 2. Также поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.

Вот тут не понятно. Я создаю:

```bash
variable "metadata_for_all" {
  type = map(any)
  default = {
    serial-port-enable = 1
  }
}
```

в `main.tf` значение `ssh-keys` - это уже переменная. 
```bash
  metadata = {
    serial-port-enable = var.metadata_for_all["serial-port-enable"]
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
```

Зачем `ssh-keys` переносить в другую переменную? 
Но все же если попытаться это сделать - будет ошибка, использовать переменную внутри переменной нельзя.

Не понимаю что тут нужно сделать. Что имеется ввиду под "эта переменная должна быть общая для всех ваших ВМ"

#### 3. Найдите и удалите все более не используемые переменные проекта.

А они есть? Я не нашел. Все переменные используются.

**main.tf**
```bash
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_ubuntu_image
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_name_platform
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_resources["web"]["cores"]
    memory        = var.vm_resources["web"]["memory"]
    core_fraction = var.vm_resources["web"]["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_name_db
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_resources["db"]["cores"]
    memory        = var.vm_resources["db"]["memory"]
    core_fraction = var.vm_resources["db"]["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadata_for_all["serial-port-enable"]
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

**vms_platform.tf**
```bash
variable "vm_db_develop_platform" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type    = string
  default = "standard-v1"
}

```

**variables.tf**
```bash
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
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb4ssWoeHjVHZPP/8Qomg+A+XewJuMsTTRakRzYvVTApKALpY0ktn1YOQG6/ff5oH8Jt14/NMLWl+O96L8DkNmdafyl0bYQvk5fxtz3hfCYOYEu4RhvkkQB29X3cEXJAq1PTo5AqgVrFoz76DzuKZYzRvbpPRK8koOm9MsYuQDEwAHpoU2..........................
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
  }
}
```

#### 4. Проверьте terraform plan. Изменений быть не должно.

```bash
src git:(main) ✗ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpg2retpc18g5eifbml]
data.yandex_compute_image.ubuntu: Read complete after 3s [id=fd81n0sfjm6d5nq6l05g]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bkg3gga2dm0fhv08it]
yandex_compute_instance.platform_db: Refreshing state... [id=fhmr7shk5m99s0jh4u4d]
yandex_compute_instance.platform: Refreshing state... [id=fhmbrjcnt19t9n80kqb0]

No changes. Your infrastructure matches the configuration.
```
------

## Дополнительное задание (со звёздочкой*)


### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

#### 1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
```bash
> local.test_list[1]
"staging"
```

#### 2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```bash
> length(local.test_list)
3
```

#### 3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```bash
> local.test_map["admin"]
"John"
```

#### 4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

```bash
"${local.test_map["admin"]} is admin for ${local.test_list[2]} server based on OS ${local.servers["production"]["image"]} with ${local.servers["production"]["cpu"]} vcpu, ${local.servers["production"]["ram"]} ram and ${length(local.servers["production"]["disks"])} virtual disks"
```