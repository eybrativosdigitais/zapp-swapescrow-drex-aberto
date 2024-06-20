# Erros Comuns (Common Issues)

## Erros de má configuração do ambiente

### `SWAPESCROW_RPC_URL` sem conexão ou mal configurado

1) Ao iniciar o comando `./startup.sh`, a aplicação `zapp-swapescrow-zapp-1` fica muito tempo (mais de 120 segundos) em estado `Waiting` e depois finaliza com a mensagem `container zapp-swapescrow-zapp-1 is unhealthy`:

   - **Possível causa**: O container `zapp-swapescrow-zapp-1` não conseguiu se conectar a Blockchain via websocket.
   - **Solução**: Verifique se a variável de ambiente `SWAPESCROW_RPC_URL` está corretamente configurada. Você pode testar a conexão Websocket usando o programa [wscat](https://www.npmjs.com/package/wscat) (`npm install -g wscat`). Para isso, execute o comando `wscat -c <SWAPESCROW_RPC_URL>`. Se a conexão for bem sucedida, você verá uma mensagem de `Connected` do servidor. Se a conexão falhar, verifique se o endereço do servidor está correto e se o servidor está acessível. Ainda é possível um teste adicionar de executar o comando `{"jsonrpc":  "2.0", "id": 0, "method":  "eth_gasPrice"}` na conexão aberta via `wscat`. Se a resposta retornar um resultado, a conexão está correta.

2) `timber-1    | error: Blockchain connection error: undefined`: A causa desse erro é a mesma do erro anterior, porém, o container `timber-1` não conseguiu se conectar a Blockchain via websocket. A solução é a mesma do erro anterior.

3) `zapp-1      | contract getContractMetadata Unable to get a contract address:  connection not open on send()`: A causa desse erro é a mesma do erro anterior. A solução é a mesma do erro anterior. Confira se a variável de ambiente `SWAPESCROW_RPC_URL` está configurado com a porta `ws://` ao invés de `http://`.

## Uma troca é iniciada mas a contraparte não recebe 

### Como funciona a criptografia no SwapEscrow?

Cada instancia do Starlight SwapEscrow usa a conta Ethereum configurada no arquivo `.env` e para cada conta, quando a instancia é carregada a primeira vez, é criada um par de chaves criptograficas que usam a curva eliptica [BabyJubJub](https://docs.iden3.io/publications/pdfs/Baby-Jubjub.pdf). Essa chave fica registrada no arquivo **orchestration/common/db/key.json**. A chave pública deste par e o endereço Ethereum da instancia Startlight SwapEscrow são registrados no mapa `zkpPublicKeys` no Smart Contract SwapShield do projeto Starlight SwapEscrow.

Os dados da contraparte são criprografados pelo remetente da proposta usando a chave pública da contraparte que esta registrada no Smart Contract SwapShield. E somente a contraparte, usando a chave privada que só ele tem, pode descriptografar os dados. Assim sendo, a contraparte (receiver) só consegue incorporar o commitment de proposta de troca (swapProposals) se o proponente (sender) encriptar os dados com a chave pública do recebedor da proposta (receiver). Ou quando da conclusão da troca, a contraparte (receiver) encripta os dados da aceitação usando a chave pública do proponente (sender) permitindo assim o proponente incorporar o commitment em seu banco de dados. 

Para efeitos de backup, os commitments (dados de cada transação) são também são criptografados com a chave privada do remetente. Assim, se for necessário restaurar um backup, o Starlight SwapEscrow poderá acessar novamente os eventos das transações, descriptografar e trazer os dados das transações para o banco de dados da instancia.

### O StartSwap ocorre mas a contraparte não recebe o commitment - chave errada

Usando o script [query.js](../starlight-utils/query.js), você pode checar se a chave publica sua e da sua contraparte estão condizentes com os arquivos key.json de vocês. Não se esqueça de configurar o arquivo .env com os dados corretos e executar `npm install` porque o starlight-utils é uma pequena aplicação utilitária a parte.

Infelizmente, se as chaves estiverem incorretas e se você perdeu o arquivo key.json anterior, você não conseguirá descriptograr e registrar os commitments e as transações serão perdidas.

Você deverá parar a instancia que esta com a chave registrada incorretamente com `docker compose down`, apague o arquivo **orchestration/common/db/key.json** e execute inicialize a aplicação novamente. Uma nova chave será gerada e registrada. Verifique novamente se esta tudo correto rodando o script [query.js](../starlight-utils/query.js). E com as chaves publicas do remetente e recebedor corretamente registradas, basta começar o fluxo novamente. 

### O StartSwap ocorre mas a contraparte não recebe o commitment - conexão websocket quebrada

Outra possibilidade é seu servidor Besu ter chegado no limite de conexões simultâneas ou a conexão entre a sua instância Starlight SwapEscrow esta falhando/caindo. Verifique seu nó Besu, baixe e inicie novamente a sua instancia, execute o backup através do endpoint POST /backupdata e verifique se agora o commitment salvo no seu banco de dados.
