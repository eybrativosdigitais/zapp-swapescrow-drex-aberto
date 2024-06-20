# Tutorial de Swap

## Introdução

Este tutorial tem como objetivo explicar como realizar um swap no SwapShield usando a rota de API. Há quatro rotas diferentes para propor um swap, sendo elas:

- [Real Tokenizado (ERC20) para TPFt (ERC1155) - `/startSwapFromErc20ToErc1155`](#a-começar-um-swap-real-tokenizado-erc20-para-tpft-erc1155---startswapfromerc20toerc1155)
- [Real Tokenizado (ERC20) para Real Tokenizado (ERC20) - `/startSwapFromErc20ToErc20`](#g-começar-um-swap-de-real-tokenizadoerc20-para-real-tokenizadoerc20---startswapfromerc20toerc20)
- [TPFt (ERC1155) para Real Tokenizado (ERC20) - `/startSwapFromErc1155ToErc20`](#c-começar-um-swap-tpft-erc1155-para-real-tokenizadoerc20---startswapfromerc1155toerc20)
- [TPFt (ERC1155) para TPFt (ERC1155) - `/startSwapFromErc1155ToErc1155`](#e-começar-um-swap-tpft-erc1155-para-tpft-erc1155---startswapfromerc1155toerc1155)

e há quatro rotas diferentes para aceitar um swap, sendo elas:

- [Real Tokenizado (ERC20) para TPFt (ERC1155) - `/completeSwapFromErc20ToErc1155`](#b-completar-um-swap-real-tokenizado-erc20-para-tpft-erc1155---completeswapfromerc20toerc1155)
- [Real Tokenizado (ERC20) para Real Tokenizado (ERC20) - `/completeSwapFromErc20ToErc20`](#h-completar-um-real-tokenizado-erc20-para-real-tokenizado-erc20---completeswapfromerc20toerc20)
- [TPFt (ERC1155) para Real Tokenizado (ERC20) - `/completeSwapFromErc1155ToErc20`](#d-completar-um-swap-tpft-erc1155-para-real-tokenizado-erc20---completeswapfromerc1155toerc20)
- [TPFt (ERC1155) para TPFt (ERC1155) - `/completeSwapFromErc1155ToErc1155`](#f-completar-um-swap-tpft-erc1155-para-tpft-erc1155---completeswapfromerc1155toerc1155)

*A rota de completeSwap que deve ser chamada deve ser equivalente à rota de startSwap que foi chamada anteriormente. Exemplo: se foi chamada a rota /startSwapFromErc20ToErc1155, a rota de completeSwap equivalente é /completeSwapFromErc20ToErc1155.*

> Lembre-se que antes de realizar o swap, é necessário que o endereço que está propondo o swap tenha tokens suficientes depositados através da rota de /depositErc20 ou /depositErc1155 suficientes para realizar a troca. Veja a seção [Depósitos](./DEPOSITOS.md) para mais informações.

## Método: Swap via API

Para realizar um swap via API, é necessário realizar uma requisição POST para a rota `/startSwapFromErc20ToErc1155` do SwapShield, passando os parâmetros necessários no corpo da requisição.

## A) Começar um Swap Real Tokenizado (ERC20) para TPFt (ERC1155) - `/startSwapFromErc20ToErc1155`

### Rota 
`POST <endereço_da_aplicação:3000>/startSwapFromErc20ToErc1155`

### Descrição
Essa rota é utilizada para iniciar um swap de Real Tokenizado (ERC20) para Título Público Federal tokenizado (TPFt) (ERC1155) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `erc20Address`       | string | Endereço do Real Tokenizado específico               | Yes      |
| `counterParty`       | string | Endereço da contraparte que receberá o swap          | Yes      |
| `amountSent`         | number | Quantidade de Real Tokenizado a ser enviada          | Yes      |
| `tokenIdReceived`    | number | Id representando a série de TPFt a ser recebida      | Yes      |
| `tokenReceivedAmount`| number | Quantidade (unidades) da série de TPFt a ser recebida| Yes      |

#### Exemplo
```json
{
  "erc20Address": "0x492e70288646359575f00F3A0598851Ea0A39662",
  "counterParty": "0xAccountBankB",
  "amountSent": 30,
  "tokenIdReceived": 1,
  "tokenReceivedAmount": 3
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

> Ao completar o Swap, será possível achar a informação do *swapId* no campo `commitment.preimage.value.swapId` da resposta.

> A contraparte também poderá saber o swapId proposto através das rotas /getAllCommitments. Os swaps propostos serão reconhecidos pela aplicação da contra-parte e será adicionads no banco de commitements. 

## B) Completar um Swap Real Tokenizado (ERC20) para TPFt (ERC1155) - `/completeSwapFromErc20ToErc1155`

### Rota
`POST <endereço_da_aplicação:3000>/completeSwapFromErc20ToErc1155`

### Descrição
Essa rota é utilizada para completar um swap de Real Tokenizado (ERC20) para Título Público Federal tokenizado (TPFt) (ERC1155) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `swapId`       | number | Id do swap a ser completado               | Yes      |

#### Exemplo
```json
{
  "swapId": 331103933
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

## C) Começar um Swap TPFt (ERC1155) para Real Tokenizado(ERC20) - `/startSwapFromErc1155ToErc20`

### Rota
`POST <endereço_da_aplicação:3000>/startSwapFromErc1155ToErc20`

### Descrição
Essa rota é utilizada para iniciar um swap de Título Público Federal tokenizado (TPFt) (ERC1155) para Real Tokenizado (ERC20) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `erc20Address`       | string | Endereço do Real Tokenizado da troca               | Yes      |
| `counterParty`       | string | Endereço da contraparte que receberá o swap          | Yes      |
| `amountReceived`         | number | Quantidade de Real Tokenizado a ser recebido          | Yes      |
| `tokenIdSent`    | number | Id representando a série de TPFt a ser enviado      | Yes      |
| `tokenSentAmount`| number | Quantidade (unidades) da série de TPFt a ser enviado| Yes      |

#### Exemplo
```json
{
    "erc20Address" : "0x492e70288646359575f00F3A0598851Ea0A39662",
    "counterParty" : "0xAccountBankB",
	"amountReceived": 30,
	"tokenIdSent" : 1,
    "tokenSentAmount" : 3
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

> Ao completar o Swap, será possível achar a informação do *swapId* no campo `commitment.preimage.value.swapId` da resposta.

> A contraparte também poderá saber o swapId proposto através das rotas /getAllCommitments. Os swaps propostos serão reconhecidos pela aplicação da contra-parte e será adicionads no banco de commitements. 

## D) Completar um Swap TPFt (ERC1155) para Real Tokenizado (ERC20) - `/completeSwapFromErc1155ToErc20`

### Rota
`POST <endereço_da_aplicação:3000>/completeSwapFromErc1155ToErc20`

### Descrição
Essa rota é utilizada para completar um swap de Título Público Federal tokenizado (TPFt) (ERC1155) para Real Tokenizado (ERC20) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `swapId`       | number | Id do swap a ser completado               | Yes      |

#### Exemplo
```json
{
  "swapId": 331103933
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

## E) Começar um Swap TPFt (ERC1155) para TPFt (ERC1155) - `/startSwapFromErc1155ToErc1155`

### Rota
`POST <endereço_da_aplicação:3000>/startSwapFromErc1155ToErc1155`

### Descrição
Essa rota é utilizada para iniciar um swap de Título Público Federal tokenizado (TPFt) (ERC1155) entre séries diferentes no SwapShield.

### Request


### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `counterParty`       | string | Endereço da contraparte que receberá o swap          | Yes      |
| `tokenIdReceived`         | number | Id representando a série de TPFt a ser recebido       | Yes      |
| `tokenReceivedAmount`         | number | Quantidade (unidades) da série de TPFt a ser recebido       | Yes      |
| `tokenIdSent`    | number | Id representando a série de TPFt a ser enviado      | Yes      |
| `tokenSentAmount`| number | Quantidade (unidades) da série de TPFt a ser enviado| Yes      |

#### Exemplo
```json
{
    "counterParty" : "0xAccountBankB",
	"tokenIdReceived": 2,
	"tokenReceivedAmount": 35,
	"tokenIdSent" : 1,
    "tokenSentAmount" : 3
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

> Ao completar o Swap, será possível achar a informação do *swapId* no campo `commitment.preimage.value.swapId` da resposta.

> A contraparte também poderá saber o swapId proposto através das rotas /getAllCommitments. Os swaps propostos serão reconhecidos pela aplicação da contra-parte e será adicionads no banco de commitements. 

## F) Completar um Swap TPFt (ERC1155) para TPFt (ERC1155) - `/completeSwapFromErc1155ToErc1155`

### Rota
`POST <endereço_da_aplicação:3000>/completeSwapFromErc1155ToErc1155`

### Descrição
Essa rota é utilizada para completar um swap de Título Público Federal tokenizado (TPFt) (ERC1155) entre séries diferentes no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `swapId`       | number | Id do swap a ser completado               | Yes      |

#### Exemplo
```json
{
  "swapId": 331103933
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

## G) Começar um Swap de Real Tokenizado(ERC20) para Real Tokenizado(ERC20) - `/startSwapFromErc20ToErc20`

### Rota
`POST <endereço_da_aplicação:3000>/startSwapFromErc20ToErc20`

### Descrição
Essa rota é utilizada para iniciar um swap de Real Tokenizado (ERC20) para Real Tokenizado (ERC20) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `erc20AddressSent`       | string | Endereço do Real Tokenizado que será enviado          | Yes      |
| `erc20AddressReceived`       | string | Endereço do Real Tokenizado que será recebido             | Yes      |
| `counterParty`       | string | Endereço da contraparte que receberá o swap          | Yes      |
| `amountSent`| number | Quantidade de Real Tokenizado a ser enviado | Yes      |
| `amountReceived`         | number | Quantidade de Real Tokenizado a ser recebido          | Yes      |

#### Exemplo
```json
{
    "erc20AddressSent" : "0x492e70288646359575f00F3A0598851Ea0A39662",
    "erc20AddressReceived" : "0x322e70288646359575f00F3A0598851Ea0A2232",
    "counterParty" : "0xAccountBankB",
    "amountSent": 50,
	"amountReceived": 30,
}
```
### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```

> Ao completar o Swap, será possível achar a informação do *swapId* no campo `commitment.preimage.value.swapId` da resposta.

> A contraparte também poderá saber o swapId proposto através das rotas /getAllCommitments. Os swaps propostos serão reconhecidos pela aplicação da contra-parte e será adicionads no banco de commitements. 

## H) Completar um Real Tokenizado (ERC20) para Real Tokenizado (ERC20) - `/completeSwapFromErc20ToErc20`

### Rota
`POST <endereço_da_aplicação:3000>/completeSwapFromErc20ToErc20`

### Descrição
Essa rota é utilizada para completar um swap de Real Tokenizado (ERC20) para Real Tokenizado (ERC20) no SwapShield.

### Request

### Body
O request deve conter os seguintes campos:

| Field                | Type   | Description                                          | Required |
|----------------------|--------|------------------------------------------------------|----------|
| `swapId`       | number | Id do swap a ser completado               | Yes      |

#### Exemplo
```json
{
  "swapId": 331103933
}
```

### Response

#### Sucesso (200 OK)
Se a solicitação for bem-sucedida, a API retornará um código de status 200 com a seguinte estrutura de resposta.

#### Exemplo de Resposta
```json
{
    "tx": {
    },
    "encEvent": [],
    "commitment": {
    }
}
```


