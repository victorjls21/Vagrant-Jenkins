#!/bin/bash

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