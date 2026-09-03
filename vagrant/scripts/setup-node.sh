#!/bin/bash

echo "================================="
echo "Instalando Node.js e NPM"
echo "================================="

apt-get update -y

apt-get install -y curl

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt-get install -y nodejs

echo "================================="
echo "Versoes instaladas:"
node --version
npm --version
echo "================================="