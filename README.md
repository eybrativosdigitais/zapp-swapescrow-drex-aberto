# Starlight SwapEscrow

O SwapEscrow é uma aplicação criada através do Starlight. Por sua vez, o Starlight é uma solução que cria aplicações de privacidade para blockchains baseadas no padrão EVM. Ela é desenvolvida e mantida pela Ernest & Young ([EYBlockchain/starlight: :zap: solidity --> zApp transpiler :zap: (github.com)​](https://github.com/EYBlockchain/starlight)).

A proposta do Starlight é simplificar a integração das provas de conhecimento zero em contratos inteligentes permitindo que o desenvolvedor possa abstrair a complexidade de circuitos criptográficos e focar apenas na lógica do contrato. Utilizando um contrato Solidity básico e anotações específicas para privacidade (decoradores), a Starlight se propõe a gerar automaticamente uma aplicação ZKP denominada ZApp (ZKP Application) com toda a infraestrutura necessária para executar os contratos mantendo a privacidade de informações.

Para o Piloto serão implementados os seguintes cenários:

- transferência de Real Digital entre duas instituições;
- compra e venda de TPFt com Real Digital.
- transferência de Real Tokenizado entre duas contas.
- trocas diretas de TPFt com séries diferentes.

As próximas seções fornecerão uma visão da estrutura da solução, seguida de um guia passo a passo elaborado para a instalação e execução.

## Índice

- [Starlight SwapEscrow](#starlight-swapescrow)
  - [Índice](#índice)
  - [Componentes do SwapEscrow](#componentes-do-swapescrow)
  - [Requisitos mínimos](#requisitos-mínimos)
  - [1. Executando o Starlight](#1-executando-o-starlight-swapescrow)
    - [Tipos de Configuração](#tipos-de-configuração)
      - [1. Configuração Padrão (recomendado)](#1-configuração-padrão-recomendado)
    - [Passo a Passo](#passo-a-passo)
    - [Observações](#observações)
  - [2 - Permissões dos contratos](#2---permissões-dos-contratos)
  - [3 - Interação com a aplicação](#3---interação-com-a-aplicação)
    - [3.1 - Configurar scripts - via Postman](#31---configurar-scripts---via-postman)
    - [3.2 - Configurar scripts - via Postman (StepByStep)](#32---configurar-scripts---via-postman-stepbystep)
  - [4 - Consulta de informações das aplicações](#4---consulta-de-informações-das-aplicações)
  - [5 - Interação com contratos de forma alternativa](#5---interação-com-contratos-de-forma-alternativa)
    - [5.1 - Interação via frontend](#51---interação-via-frontend)
  - [6 - Endereços dos contratos](#6---endereços-dos-contratos)
  - [7 - Interagindo com o sistema](#7---interagindo-com-o-sistema)
  - [8 - Configuração inicial alternativa](#8---configuração-inicial-alternativa)
    - [8.1) Configuração tipo 2 (Criando a imagem localmente)](#81-configuração-tipo-2-criando-a-imagem-localmente)
    - [8.2) Configuração tipo 3 (Hospedando Mongo localmente)](#82-configuração-tipo-3-hospedando-mongo-localmente)

## Componentes do SwapEscrow

Todas as interações com as aplicações criadas pelo Starlight, como o SwapEscrow, são realizadas através do cliente ZApp, que opera localmente em cada nó da rede. Cada aplicação Zapp é constituída pelos seguintes serviços:

- **Zapp ou Orchestrator**: este é o aplicativo cliente principal. Funciona como um orquestrador de operações entre os demais serviços. As interações com o aplicativo se dão por meio de APIs que estão dentro do Zapp/Orchestrador
- **Timber**: responsável por sincronizar a merkle-tree dos *commitments* com as informações privadas locais e as informações públicas registradas na rede DLT
- **Zokrates-worker**: responsável pela geração das provas de conhecimento zero
- **MongoDB**: base de dados utilizada pelo Zapp e pelo Timber para salvar os *commitments* e o estado do merkle-tree, respectivamente

## Requisitos mínimos

Abaixo segue os requisitos mínimos de Sistema Operacional, Docker, Ambiente de Execução e de Hardware do mesmo:

- Execução em Servidor em Máquina Virtual Dedicada - não Desktop
- Sistema operacional Linux, distribuição Red Hat ou Ubuntu
- Docker Engine versão v26.1 ou superior
- 8 Gb de Memória RAM
- 32 GB de Disco SSD
- 2 vCPU
- Conexão a um nó Besu que esteja conectado a rede Blockchain DREX via Websocket

> Não podemos garantir o correto funcionamento da aplicação se a mesma for executada em máquinas Desktop ou com requisitos inferiores aos citados acima.

## 1. Executando o Starlight SwapEscrow

A primeira etapa será a configuração inicial do sistema. Há 3 formas diferentes de realizar essa configuração, cada uma com o seu respectivo arquivo de docker-compose. O foco deste guia será a configuração tipo 1, na qual utiliza um Mongo externo e baixa o restante das imagens do GHCR (Github Container Registry). Para checar as outras formas, vá em [Configurações alternativas](#8---configuração-inicial-alternativa).

### Tipos de Configuração

#### 1. Configuração Padrão (recomendado)

### Passo a Passo

1) Clonar o projeto:

    ```bash
    git clone https://github.com/eybrativosdigitais/zapp-swapescrow-drex
    ```

2) Entrar no diretório do projeto:

    ```bash
    cd zapp-swapescrow-drex
    ```

3) Criar o arquivo `env` copiando do exemplo:

    ```bash
    cp env.example .env
    ```

4) Preencher o arquivo .env com as informações necessárias:
   - Apontar para o seu fullnode no parâmetro: `SWAPESCROW_RPC_URL=ws://host:porta`
   - Endereço da sua conta: `DEFAULT_ACCOUNT`
   - Chave da sua conta default: `KEY`
   - Url de conexão com o Mongo: `MONGO_URL`

5) Copiar o arquivo de configuração do Docker Compose:

    ```bash
    cp docker-compose.external-db-using-image.yml docker-compose.yml
    ```

> IMPORTANTE: mesmo com a configuração acima usando imagens Dockers que constam no repositório Github Container Repository, são requeridos que os seguintes diretórios estejam no mesmo diretório onde estejam os arquivos .env e docker-compose.yml. São eles: circuits, proving-files, orchestration/common/db, build e config.

6) Dar permissões de execução para o script de inicialização:

    ```bash
    chmod +x ./startup.sh
    ```

7) Inicializar os serviços:

    ```bash
    ./startup.sh
    ```

8) Verificar se todos os containers estão up: `docker ps`. O log deverá ser semelhante ao abaixo:

    | CONTAINER ID | IMAGE                                                 | COMMAND                  | CREATED     | STATUS   | PORTS                                       | NAMES                             |
    |--------------|-------------------------------------------------------|--------------------------|-------------|----------|---------------------------------------------|-----------------------------------|
    | 3e52d5d9a6ea | zapp-swapescrow-zapp                                  | "docker-entrypoint.s…"   | 45 seconds ago  | Up 30 seconds| 0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   | zapp-swapescrow-zapp-1            |
    | 0594e1178515 | zapp-swapescrow-timber                                | "docker-entrypoint.s…"   | 45 seconds ago  | Up 30 seconds| 0.0.0.0:3100->80/tcp, :::3100->80/tcp       | zapp-swapescrow-timber-1          |
    | b7b53b8b0a63 | ghcr.io/eyblockchain/zokrates-worker-updated:latest   | "/bin/sh -c 'npm sta…"   | 45 seconds ago  | Up 30 seconds| 0.0.0.0:8080->80/tcp, :::8080->80/tcp       | zapp-swapescrow-zokrates-1        |

9) Exibir os logs:

    ```bash
    docker compose logs -f -n 1000 timber zapp zokrates
    ```

10) A configuração inicial está completa! Se os logs não apresentaram erros. Caso tenha acontecido algum erro, vá até a seção [Erros comuns](./docs/ERROS.md) checar se há alguma solução já conhecida.

### Observações

- Alterar as configurações do seu nó Besu, aumentando ou desabilitando o limite RPC para logs (parâmetro [RPC-MAX-LOGS-RANGE](https://besu.hyperledger.org/23.4.0/public-networks/reference/cli/options#rpc-max-logs-range)) (necessário para o correto funcionamento do Timber)

- Permitir conexões Websocket no seu nó Besu (parâmetro [--rpc-ws-enabled=true](https://besu.hyperledger.org/23.7.3/public-networks/reference/cli/options#rpc-ws-api)) (necessário para o correto funcionamento do Zapp e Timber)

- Outros configurações da conexão Websocket do seu nó Besu, importantes para o bom funcionamento: 

```
--rpc-ws-enabled \
--rpc-ws-api="ETH,WEB3,NET" \
--rpc-ws-host=0.0.0.0 \
```

## 2 - Permissões dos contratos

Foi realizado o deploy do contrato inteligente denominado **SwapShield** responsável por gerenciar os *commitments* do Starlight para os testes de transferência, assegurando que os saldos permaneçam criptografados na rede. Para participar dos testes, os envolvidos no projeto piloto deverão realizar um depósito de Real tokenizado (ERC20) e de TPFt (ERC1155) neste contrato.

Isso requer a autorização do contrato **SwapShield** para duas ações:

- a) Retirar o Real Digital da carteira Ethereum do participante. É feito por meio do **approve** do valor no contrato de Real Digital. O endereço do contrato de SwapShield que necessita autorização está especificado na seção [Endereços](#6---endereços-dos-contratos).
- b) Retirar os Títulos Públicos Federais tokenizados (TPFt) da carteira Ethereum do participante. É feito por meio do **setApprovalForAll**. O endereço do contrato de SwapShield que necessita autorização está especificado na seção [Endereços](#6---endereços-dos-contratos).

## 3 - Interação com a aplicação

O foco será a interação via Postman, mas também é possível interagir via frontend da aplicação ou cURL. Você pode checar essas outras formas de interação na seção [Interações alternativas](#5---interação-com-contratos-de-forma-alternativa).

### 3.1 - Configurar scripts - via Postman

Existem duas coleções do Postman na raiz do projeto. Na coleção `StepByStep`, encontram-se as sequências padrão de interação com a aplicação. Na coleção `SwapEscrow.postman_collection.json`, há rotas adicionais para depuração da aplicação.

Para configurar o Postman, siga os passos abaixo:

- Importe o arquivo [./SwapEscrow.postman_collection.json](SwapEscrow.postman_collection) no [Postman](https://www.postman.com/downloads/).
- Dentro do Postman, clique no nome da pasta e defina as seguintes propriedades na aba variáveis:
  - `bank_a_zapp`: Servidor onde está rodando a sua aplicação, o valor default é `http://localhost:3000`
  - `swapShield_address`: Endereço do contrato de SwapShield na rede DREX
  - `accountBankA`: Preencher com a sua conta Ethereum que será utilizada para o teste
  - `accountBankB`: A conta Ethereum da instituição que será sua contra-parte nas operações
  - `erc_1155_address`: Endereço do contrato do TPFt na rede DREX
  - `erc_20_address`: Endereço do contrato de real digital utilizado na troca na rede DREX
  - `erc_20_address_test`: Endereço de outro possível contrato de real tokenizado utilizado na troca na rede DREX
  - `bank_b_zapp`: *Campo não obrigatório* - Servidor onde está rodando a aplicação de sua contra-parte o valor default é `http://localhost:3003`. Este campo é útil caso esteja testando entre dois bancos próprios.

<p align="center">
  <img src="https://starlight-readme.s3.amazonaws.com/postman-config.png" alt="Configuração Postman"/>
</p>

### 3.2 - Configurar scripts - via Postman (StepByStep)

A coleção StepByStep já contém pastas com os passos específicos dos testes do piloto. Será necessário a configuração de mesmas variáveis do passo anterior para que os scripts funcionem corretamente. Para isso, repita o processo de configuração de variáveis descrito na seção [Configurar scripts - via Postman](#31---configurar-scripts---via-postman).

## 4 - Consulta de informações das aplicações

Na aplicação, há um frontend com rotas para consultar o status. Para acessá-lo, basta abrir o navegador e ir até o endereço http://<endereço_da_aplicacao>:3000. Nesse frontend, é possível verificar o *status da aplicação*, os *commitments* e os *balanços privados* (também chamados de shielded) do seu endereço. Para isso, você pode navegar pelas páginas "Info", "Balanços" e "Commitments".

> É possível através dessa interface, realizar as ações de "Depósito", "Troca" e "Retirada" de Real Digital e TPFt, sendo uma forma alternativa ao Postman.

<p align="center">
  <img src="https://starlight-readme.s3.amazonaws.com/starlight-frontend.png" alt="Frontend - Info"/>
</p>

## 5 - Interação com contratos de forma alternativa

### 5.1 - Interação via frontend

A aplicação possui um frontend que permite a interação com os contratos. Para acessar, basta acessar o endereço `http://<endereço_da_aplicação>:3000` no navegador. Neste frontend, é possível realizar todos os passos de interação com os contratos que estão disponíveis nas rotas do Postman. Para isso, você pode começar pela tela de Depósito da aplicação.

Na seção já foi coberta [Consulta de informações das aplicações](#4---consulta-de-informações-das-aplicações) as informações que podem ser consultadas no frontend.

## 6 - Endereços dos contratos

- **SwapShield**: Ainda não definido
- **Real Digital (ERC20)**: Ainda não definido
- **TPFt (ERC1155)**: Ainda não definido

## 7 - Interagindo com o sistema

Para interagir com o sistema, você pode utilizar o Postman ou o frontend da aplicação. A seguir, serão apresentadas as 3 ações disponíveis na aplicação e suas variações (Depositar, Trocar e Retirar).

1) [**Depositar**](./docs/DEPOSITOS#.MD) - Há dois tipos de depósito, um para Real Digital e outro para TPFt:
   - [**Depositar Real Tokenizado (ERC20)**: `/depositErc20`](./docs/DEPOSITOS.md#a-depositar-real-tokenizado-erc20--depositerc20)
   - [**Depositar TPFt (ERC1155)**: `/depositErc1155`](./docs/DEPOSITOS.md#b-depositar-tpft-erc1155--depositerc1155)

2) [**Trocar**](./docs/SWAPS.md)) - As trocas (ou swaps) ocorrem em duas etapas. A parte que irá propor a troca, começará o swap por meio das rotas de `/startSwap`. Ao fim da proposta, será gerado um ID de troca, a contraparte pode completar a troca através desse ID gerado, utilizando as rotas de `/completeSwap`. Há 4 formas de troca, que depende do que será enviado e recebido, sendo elas:
   
   - [**Trocar Real Tokenizado por TPFt**: `/startSwapErc20ToErc1155`](./docs/SWAPS.md)
   - [**Trocar TPFt por Real Tokenizado**: `/startSwapErc1155ToErc20`](./docs/SWAPS.md))
   - [**Trocar Real Tokenizado por Real Tokenizado**: `/startSwapErc20ToErc20`](./docs/SWAPS.md))
   - [**Trocar TPFt Tokenizado por TPFt**: `/startSwapErc1155ToErc1155`](./docs/SWAPS.md))
  
3) [**Retirar**]() - Há dois tipos de retirada, um para Real Digital e outro para TPFt:
   
   - [**Retirar Real Tokenizado (ERC20)**: `/withdrawErc20`]()
   - [**Retirar TPFt (ERC1155)**: `/withdrawErc1155`]()

## 8 - Configuração inicial alternativa

Nesta etapa será apresentado duas formas alternativas de configuração inicial do sistema. A primeira é a criação da imagem localmente e a segunda é a hospedagem do Mongo localmente.

### 8.1) Configuração tipo 2 (Criando a imagem localmente)

Repita os passos 1 a 4 da seção [Configuração tipo 1](#11-configuração-tipo-1-recomendado). O único passo que haveŕa diferença é o passo 5, onde será necessário criar o arquivo docker-compose.yml copiando o exemplo: `cp docker-compose.external-db-using-dockerfile.yml docker-compose.yml`.

### 8.2) Configuração tipo 3 (Hospedando Mongo localmente)

Repita os passos 1 a 4 da seção [Configuração tipo 1](#11-configuração-tipo-1-recomendado). O único passo que haveŕa diferença é o passo 5, onde será necessário criar o arquivo docker-compose.yml copiando o exemplo: `cp docker-compose.unsafe-local-db-using-dockerfile docker-compose.yml`.

> Observação: Ao usar este método, esteja ciente que o banco de dados será apagado toda vez que o container for reiniciado com a flag `-v`. Isso poderá gerar erros ou complicações para a aplicação. Para ambientes de produção, é recomendado o uso de um banco de dados externo.

