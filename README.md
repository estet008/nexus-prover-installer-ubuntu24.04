# Nexus Prover Installer — README

## 📋 Мінімальні вимоги до сервера

* ✅ **Операційна система:** Ubuntu 24.04 LTS
* ✅ **Процесор:** 2 ядра (x86\_64)
* ✅ **Оперативна памʼять:** мінімум 2 GB
* ✅ **Дисковий простір:** мінімум 10 GB вільного простору
* ✅ **Інтернет:** стабільне підключення

## 🚀 Рекомендовані вимоги для оптимальної роботи

* 🏆 **Операційна система:** Ubuntu 24.04 LTS (свіжа інсталяція)
* 🏆 **Процесор:** 4 ядра (або більше)
* 🏆 **Оперативна памʼять:** 8 GB або більше
* 🏆 **Дисковий простір:** SSD з 50 GB+ вільного місця
* 🏆 **Інтернет:** постійне зʼєднання без обривів, швидкість від 10 Mbps

## 🐳 Залежності

Перед запуском скрипта переконайтесь, що ваш сервер оновлений та має встановлені всі необхідні компоненти:

### 🔧 Підготовка системи

```bash
sudo apt update && sudo apt upgrade -y
```

### 🐋 Встановлення Docker

```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

> ⚠️ Після додавання до групи `docker` рекомендовано перезайти в систему або виконати `newgrp docker`

* 📦 **systemd** (встановлено за замовчуванням в Ubuntu 24.04)

## ⚙️ Встановлення Nexus Prover (через Docker)

1. Завантажте скрипт встановлення:

   ```bash
   curl -O https://raw.githubusercontent.com/estet008/nexus-prover-installer/main/install.sh
   chmod +x install.sh
   ./install.sh
   ```
2. Введіть ваш `NODE ID` при запиті скрипта.
3. Скрипт створить Docker-контейнер і налаштує systemd-сервіс для автозапуску.

## 🛠️ Керування Nexus Prover через systemd

* 🔍 Перевірити статус:

  ```bash
  sudo systemctl status nexus-docker-prover
  ```
* 🟢 Запустити вручну:

  ```bash
  sudo systemctl start nexus-docker-prover
  ```
* 🔴 Зупинити вручну:

  ```bash
  sudo systemctl stop nexus-docker-prover
  ```
* ♻️ Перезапустити:

  ```bash
  sudo systemctl restart nexus-docker-prover
  ```
* 🚫 Вимкнути автозапуск:

  ```bash
  sudo systemctl disable nexus-docker-prover
  ```

## 📄 Логи

Переглянути вивід процесу в реальному часі:

```bash
sudo docker logs -f nexus-instance
```

## 🔄 Оновлення Nexus CLI (у Docker)

### 🧼 Очищення та перевстановлення (однією командою)

```bash
sudo systemctl stop nexus-docker-prover && \
  sudo docker rm -f nexus-instance && \
  sudo docker rmi nexusprover && \
  curl -O https://raw.githubusercontent.com/estet008/nexus-prover-installer/main/install.sh && \
  chmod +x install.sh && \
  ./install.sh
```

> 🆕 Скрипт автоматично отримає останню версію Nexus CLI з офіційного джерела.

## 🔍 Перевірка версії Nexus CLI (у Docker)

```bash
sudo docker exec -it nexus-instance /home/prover/.nexus/bin/nexus-network --version
```

> Якщо команда повертає помилку «No such file or directory», CLI не встановлено або ще не завантажено через мережеві обмеження.

## ℹ️ Примітка

Під час Testnet III очікується, що Nexus CLI може не запускатися автоматично або видавати повідомлення про "No such device or address" — це не помилка, а очікувана поведінка під час тестування мережі.

---
