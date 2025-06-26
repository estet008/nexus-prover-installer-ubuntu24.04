#!/bin/bash

set -e

# ---------------------------
# Nexus Prover Installer (Ubuntu 24.04+)
# Підтримка через Docker з glibc >=2.39
# ---------------------------

# 🔍 Перевірка наявності Docker
if ! command -v docker &> /dev/null; then
  echo "❌ Docker не встановлено. Будь ласка, встановіть Docker перед запуском цього скрипта."
  echo "Інструкція: https://docs.docker.com/engine/install/"
  exit 1
fi

# Запит Node ID у користувача, якщо не передано як змінна середовища
if [[ -z "$NODE_ID" ]]; then
  echo -n "🔢 Введіть ваш NODE ID: "
  read NODE_ID
fi
NODE_ID_CLEAN=$(echo "$NODE_ID" | tr -d '[:space:]' | sed 's/[^a-zA-Z0-9_-]//g')

# Перевірка на порожній ввід
if [[ -z "$NODE_ID_CLEAN" ]]; then
  echo "❌ Помилка: Node ID не може бути порожнім або містити недійсні символи"
  exit 1
fi

IMAGE_NAME="nexusprover"

# Крок 1: Підготовка директорії
mkdir -p ~/nexus-prover && cd ~/nexus-prover

# Крок 2: Створення Dockerfile
cat <<EOF > Dockerfile
FROM ubuntu:24.04

RUN apt update && apt install -y \
    curl unzip ca-certificates \
    libssl-dev libcurl4-openssl-dev \
    tzdata bsdutils

RUN useradd -ms /bin/bash prover

USER prover
WORKDIR /home/prover
ENV HOME=/home/prover

RUN curl -sSf https://cli.nexus.xyz/ -o install.sh \
 && chmod +x install.sh \
 && NONINTERACTIVE=1 ./install.sh \
 || echo "⚠️ Попередження: Nexus CLI не встановлено. Це очікувана поведінка під час Testnet III."

COPY --chown=prover:prover entrypoint.sh /home/prover/entrypoint.sh
RUN chmod +x /home/prover/entrypoint.sh

ENTRYPOINT ["/home/prover/entrypoint.sh"]
EOF

# Крок 3: Створення скрипта запуску в контейнері
cat <<EOF > entrypoint.sh
#!/bin/bash

NODE_ID_CLEAN=\$(echo "\$NODE_ID" | tr -d '[:space:]' | sed 's/[^a-zA-Z0-9_-]//g')

if [[ -z "\$NODE_ID_CLEAN" ]]; then
  echo "❌ NODE_ID не передано у середовищі контейнера"
  exit 1
fi

for i in {1..10}; do
  if [[ -x /home/prover/.nexus/bin/nexus-network ]]; then
    echo "✅ Знайдено nexus-network. Запуск..."
    script -q -c "/home/prover/.nexus/bin/nexus-network start --node-id \"\$NODE_ID_CLEAN\"" /dev/null
    exit \$?
  fi
  echo "🔄 Очікування появи nexus-network... Спроба \$i"
  sleep 5
  done

echo "⚠️ nexus-network так і не з'явився. Можливо, Testnet III ще не запущено."
exit 0
EOF

# Крок 4: Побудова Docker-образу
sudo docker build -t $IMAGE_NAME .

# Крок 5: Створення системного сервісу для автозапуску після перезавантаження
SERVICE_NAME="nexus-docker-prover"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Nexus Prover Docker Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a nexus-instance
ExecStop=/usr/bin/docker stop -t 2 nexus-instance

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME

# Крок 6: Створення контейнера
sudo docker rm -f nexus-instance &>/dev/null || true
sudo docker create \
  --name nexus-instance \
  --restart unless-stopped \
  -e NODE_ID=$NODE_ID_CLEAN \
  $IMAGE_NAME

# Крок 7: Запуск контейнера через systemd
sudo systemctl start $SERVICE_NAME

# Крок 8: Готово
echo "✅ Nexus Prover встановлено і запущено в Docker-контейнері!"
echo "🔁 Перевірити логи: docker logs -f nexus-instance"
echo "🛑 Зупинити: docker stop nexus-instance"
echo "♻️ Перезапустити: docker restart nexus-instance"
echo "🧷 Автозапуск контейнера налаштовано як systemd-сервіс: $SERVICE_NAME"
echo "👉 NODE ID був зчитаний під час встановлення. Щоб змінити — перезапустіть скрипт."
echo "💙 Слава Україні!"
echo

echo "📌 Команди для керування автозапуском (systemd):"
echo "🔍 Статус:     sudo systemctl status $SERVICE_NAME"
echo "🟢 Запуск:     sudo systemctl start $SERVICE_NAME"
echo "🔴 Зупинка:    sudo systemctl stop $SERVICE_NAME"
echo "♻️ Перезапуск: sudo systemctl restart $SERVICE_NAME"
echo "🚫 Вимкнути автозапуск: sudo systemctl disable $SERVICE_NAME"

