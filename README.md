# Arquitetura de Processamento de Pedidos

Este projeto implementa uma arquitetura completa para processar pedidos em um ambiente na nuvem utilizando serviços da AWS, incluindo **VPC**, **Kinesis**, **Aurora MySQL**, **EventBridge**, **Lambdas**, e outros componentes integrados.

## Componentes Principais

1. **VPC (Virtual Private Cloud)**:
   - Criada para isolar e organizar os recursos da infraestrutura.
   - Sub-redes:
     - Sub-redes públicas: Usadas para componentes que precisam de acesso à internet.
     - Sub-redes privadas: Usadas para recursos internos, como o banco de dados Aurora.
   - Regras de roteamento e grupos de segurança configurados para permitir comunicação entre os serviços.

2. **Kinesis Data Streams**:
   - Processamento de eventos em tempo real para integração com o banco de dados e serviços downstream.

3. **Aurora MySQL**:
   - Banco de dados relacional para armazenar os pedidos e manter a consistência dos dados.

4. **EventBridge**:
   - Orquestração de eventos, permitindo comunicação desacoplada entre os componentes.

5. **AWS Lambda**:
   - Funções criadas para processar eventos:
     - `ProcessarPedido`: Publica eventos no EventBridge.
     - `AtualizarEstoque`: Atualiza informações no DynamoDB.
     - `NotificarCliente`: Envia notificações via SNS.

6. **DynamoDB**:
   - Utilizado para armazenar o inventário com alta disponibilidade e escalabilidade.

7. **SNS (Simple Notification Service)**:
   - Envia notificações aos clientes após o processamento do pedido.

## Arquitetura

A arquitetura utiliza uma **VPC** criada especificamente para este projeto, organizando os recursos em sub-redes públicas e privadas. O diagrama de arquitetura pode ser encontrado [aqui](#).

## Fluxo de Dados

1. Um evento é gerado no **Aurora MySQL** e capturado pelo **DMS**, que o encaminha para o **Kinesis Data Streams**.
2. A função Lambda `ProcessarPedido` consome o evento do Kinesis e publica no **EventBridge**.
3. O EventBridge dispara eventos para as funções:
   - `AtualizarEstoque`: Atualiza informações no **DynamoDB**.
   - `NotificarCliente`: Envia notificações usando o **SNS**.

## Pré-requisitos

- **Terraform** v1.3.0 ou superior.
- AWS CLI configurada.
- Permissões apropriadas para criar e gerenciar recursos na AWS.

## Configuração e Implantação

1. Clone o repositório:
   ```bash
   git clone https://github.com/7Gabriel/aws-arch-event.git
   cd aws-arch-event
