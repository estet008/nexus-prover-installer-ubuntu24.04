# Nexus Prover Installer — README

## 📋 Мінімальні вимоги до сервера

* ✅ **Операційна система:** Ubuntu 24.04 LTS
* ✅ **Процесор:** 2 ядра (x86\_64)
* ✅ **Оперативна памʼять:** мінімум 2 GB
* ✅ **Дисковий простір:** мінімум 10 GB вільного простору
* ✅ **Інтернет:** стабільне підключення

## 🚀 Рекомендовані вимоги для оптимальної роботи

* 🏆 **Операційна система:** Ubuntu 24.04 LTS
* 🏆 **Процесор:** 4 ядра (або більше)
* 🏆 **Оперативна памʼять:** 8 GB або більше
* 🏆 **Дисковий простір:** SSD з 50 GB+ вільного місця
* 🏆 **Інтернет:** постійне зʼєднання без обривів, швидкість від 10 Mbps

## 🐳 Залежності

Перед запуском скрипта обовʼязково встановіть:

* Docker

  * Встановлення на Ubuntu:

    ```bash
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    ```
  * Інструкція: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)
* systemd (передвстановлено у більшості версій Ubuntu)

## ⚙️ Встановлення Nexus Prover

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

## 🔄 Оновлення Nexus CLI

Щоб оновити Nexus CLI до останньої версії, виконайте:

```bash
~/.nexus/bin/nexus-network self-update
```

## 🔍 Перевірка версії Nexus CLI

Щоб перевірити поточну встановлену версію:

```bash
~/.nexus/bin/nexus-network --version
```

## ℹ️ Примітка

Під час Testnet III очікується, що Nexus CLI може не запускатися автоматично або видавати повідомлення про "No such device or address" — це не помилка, а очікувана поведінка під час тестування мережі.

---
