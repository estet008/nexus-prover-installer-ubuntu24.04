# Nexus Prover Installer — README

## 📋 Мінімальні вимоги до сервера

* ✅ **Операційна система:** Ubuntu 24.04 LTS
* ✅ **Процесор:** 2 ядра (x86\_64)
* ✅ **Оперативна памʼять:** мінімум 2 GB
* ✅ **Дисковий простір:** мінімум 10 GB вільного простору
* ✅ **Інтернет:** стабільне підключення

## 🐳 Залежності

Перед запуском скрипта обовʼязково встановіть:

* Docker

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

## ℹ️ Примітка

Під час Testnet III очікується, що Nexus CLI може не запускатися автоматично або видавати повідомлення про "No such device or address" — це не помилка, а очікувана поведінка під час тестування мережі.

---
