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
echo "Ambiente de producao configurado!"
echo "================================="

echo "Autorizando chave da VM jenkins..."

install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh
cat /tmp/id_deploy.pub >> /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
rm -f /tmp/id_deploy.pub