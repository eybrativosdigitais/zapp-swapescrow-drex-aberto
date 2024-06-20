# Erros Comuns (Common Issues)

## Erros de má configuração do ambiente

### `SWAPESCROW_RPC_URL` sem conexão ou mal configurado

1) Ao iniciar o comando `./startup.sh`, a aplicação `zapp-swapescrow-zapp-1` fica muito tempo (mais de 120 segundos) em estado `Waiting` e depois finaliza com a mensagem `container zapp-swapescrow-zapp-1 is unhealthy`:

   - **Possível causa**: O container `zapp-swapescrow-zapp-1` não conseguiu se conectar a Blockchain via websocket.
   - **Solução**: Verifique se a variável de ambiente `SWAPESCROW_RPC_URL` está corretamente configurada. Você pode testar a conexão Websocket usando o programa [wscat](https://www.npmjs.com/package/wscat) (`npm install -g wscat`). Para isso, execute o comando `wscat -c <SWAPESCROW_RPC_URL>`. Se a conexão for bem sucedida, você verá uma mensagem de `Connected` do servidor. Se a conexão falhar, verifique se o endereço do servidor está correto e se o servidor está acessível. Ainda é possível um teste adicionar de executar o comando `{"jsonrpc":  "2.0", "id": 0, "method":  "eth_gasPrice"}` na conexão aberta via `wscat`. Se a resposta retornar um resultado, a conexão está correta.

2) `timber-1    | error: Blockchain connection error: undefined`: A causa desse erro é a mesma do erro anterior, porém, o container `timber-1` não conseguiu se conectar a Blockchain via websocket. A solução é a mesma do erro anterior.

3) `zapp-1      | contract getContractMetadata Unable to get a contract address:  connection not open on send()`: A causa desse erro é a mesma do erro anterior. A solução é a mesma do erro anterior. Confira se a variável de ambiente `SWAPESCROW_RPC_URL` está configurado com a porta `ws://` ao invés de `http://`.
