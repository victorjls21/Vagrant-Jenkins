# Vagrant-Jenkins

Ambiente de laboratório com duas VMs provisionadas via Vagrant (uma com Jenkins, outra simulando produção) e uma API Node.js de exemplo usada como alvo do pipeline CI/CD.

## Estrutura

```
.
├── app/                      # API Node.js (Express)
│   ├── server.js             # Sobe a aplicação na porta 3000
│   ├── src/app.js            # Rotas da API
│   ├── test/app.test.js      # Testes com Jest + Supertest
│   └── package.json
└── vagrant/
    ├── Vagrantfile           # Define as VMs jenkins e prod
    ├── scripts/
    │   ├── setup-node.sh     # Instala Node.js 20 e NPM (roda nas duas VMs)
    │   ├── setup-jenkins.sh  # Instala Java 21 e Jenkins na VM jenkins
    │   └── setup-prod.sh     # Valida o ambiente da VM prod
    └── ssh/
```

## Máquinas virtuais

| VM        | Box            | IP privado    | Recursos        | Provisionamento   |
| --------- | -------------- | ------------- | --------------- | ----------------- |
| `jenkins` | ubuntu/jammy64 | 192.168.56.10 | 1 vCPU, 1024 MB | Node.js + Jenkins |
| `prod`    | ubuntu/jammy64 | 192.168.56.20 | 1 vCPU, 1024 MB | Node.js           |

A VM `jenkins` também expõe a porta 8080 do guest na porta 8080 do host (com `auto_correct`), então o Jenkins fica acessível em `http://localhost:8080` ou `http://192.168.56.10:8080`.

## Pré-requisitos

- VirtualBox
- Vagrant
- Node.js 20 (apenas se quiser rodar a aplicação direto na máquina host)

## Subindo o ambiente

```bash
cd vagrant

vagrant up            # sobe as duas VMs
vagrant up jenkins    # ou apenas uma delas
vagrant up prod
```

Comandos úteis:

```bash
vagrant status        # estado das VMs
vagrant ssh jenkins   # acessa a VM
vagrant halt          # desliga
vagrant destroy       # remove as VMs
```

## Primeiro acesso ao Jenkins

Depois que a VM `jenkins` terminar de provisionar, pegue a senha inicial:

```bash
vagrant ssh jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Abra `http://localhost:8080`, cole a senha e siga o assistente de instalação.

## A aplicação

API em Express com três rotas:

| Método | Rota        | Resposta                                        |
| ------ | ----------- | ----------------------------------------------- |
| GET    | `/`         | `{ "mensagem": "API funcionando com Jenkins" }` |
| GET    | `/usuarios` | Lista de usuários (dados em memória)            |
| GET    | `/status`   | `{ "status": "online" }`                        |

Rodando localmente:

```bash
cd app
npm install
npm start     # sobe em 0.0.0.0:3000
npm test      # roda os testes com Jest
npm run build # etapa de build (placeholder)
```

Os scripts `test` e `build` do `package.json` são os que o pipeline do Jenkins consome.

## Observações

- O `Jenkinsfile` ainda não está no repositório. O pipeline precisa ser configurado no Jenkins apontando para os scripts `npm install`, `npm test` e `npm run build`, com o deploy indo para a VM `prod`.
- A pasta `vagrant/ssh/` está reservada para as chaves usadas na comunicação entre a VM do Jenkins e a de produção. Não versione chaves privadas.
- O diretório `.vagrant/` está no `.gitignore`.
