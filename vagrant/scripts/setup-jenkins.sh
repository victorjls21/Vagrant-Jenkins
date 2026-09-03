#!/bin/bash
set -e

echo "================================="
echo "Instalando Jenkins"
echo "================================="

apt-get update -y

echo "Instalando Java..."
apt-get install -y fontconfig openjdk-21-jre

echo "Adicionando repositorio do Jenkins..."

mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

echo "Instalando Jenkins..."
apt-get install -y jenkins

echo "Iniciando Jenkins..."
systemctl enable jenkins
systemctl start jenkins

echo "================================="
echo "Jenkins instalado com sucesso!"
echo "================================="

echo "Configurando acesso SSH para a VM prod..."

install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh
mv /tmp/id_deploy /home/vagrant/.ssh/id_deploy
chown vagrant:vagrant /home/vagrant/.ssh/id_deploy
chmod 600 /home/vagrant/.ssh/id_deploy

cat > /home/vagrant/.ssh/config << 'CFG'
Host prod
  HostName 192.168.56.20
  User vagrant
  IdentityFile ~/.ssh/id_deploy
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
CFG
chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config

install -d -m 700 -o jenkins -g jenkins /var/lib/jenkins/.ssh
cp /home/vagrant/.ssh/id_deploy /var/lib/jenkins/.ssh/id_deploy
cp /home/vagrant/.ssh/config /var/lib/jenkins/.ssh/config
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 600 /var/lib/jenkins/.ssh/id_deploy /var/lib/jenkins/.ssh/config