#!/bin/bash

set -e

echo "================================="
echo "Configurando ambiente de producao"
echo "================================="

echo "Hostname da maquina:"
hostname

echo "Versao do Node.js:"
node --version

echo "Versao do NPM:"
npm --version

echo "================================="
echo "Autorizando chave da VM jenkins..."
echo "================================="

# Cria a pasta .ssh do usuario vagrant
install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh

# Adiciona a chave publica apenas se ela ainda nao estiver autorizada
if [ -f /tmp/id_deploy.pub ]; then
    touch /home/vagrant/.ssh/authorized_keys

    if ! grep -qxF "$(cat /tmp/id_deploy.pub)" /home/vagrant/.ssh/authorized_keys; then
        cat /tmp/id_deploy.pub >> /home/vagrant/.ssh/authorized_keys
    fi

    chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys

    rm -f /tmp/id_deploy.pub
fi

echo "================================="
echo "Configurando aplicacao Node.js"
echo "================================="

APP_DIR="/home/vagrant/app"

if [ -f "$APP_DIR/package.json" ]; then

    cd "$APP_DIR"

    echo "Instalando dependencias..."
    sudo -u vagrant npm ci --no-bin-links

    echo "Criando servico da aplicacao..."

    cat > /etc/systemd/system/node-app.service <<'EOF'
[Unit]
Description=Aplicacao Node.js - Producao
After=network.target
RequiresMountsFor=/home/vagrant/app

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/app
Environment=NODE_ENV=production
ExecStart=/usr/bin/node /home/vagrant/app/server.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable node-app
    systemctl restart node-app

    echo "Aplicacao configurada para iniciar automaticamente."

else
    echo "AVISO: package.json nao encontrado em $APP_DIR"
fi

echo "================================="
echo "Ambiente de producao configurado!"
echo "================================="