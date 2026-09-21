# ping_test

Painel de diagnóstico de rede em `tmux`. O comando abre quatro painéis com testes para Cloudflare DNS, Google DNS, resolução de `google.com` e rota até `8.8.8.8`.

## Requisitos

- `bash`
- `tmux`
- `ping` (pacote `iputils-ping` em distribuições Debian/Ubuntu)
- `traceroute`

No Debian/Ubuntu:

```bash
sudo apt update
sudo apt install tmux iputils-ping traceroute
```

## Uso

Torne o script executável, se necessário:

```bash
chmod +x ping_test
```

Execute a partir da pasta do projeto:

```bash
./ping_test
```

O painel ocupa toda a área disponível no terminal atual. Para encerrar a sessão do `tmux`, use `Ctrl+b`, depois `d` para desconectar, ou execute:

```bash
tmux kill-session -t pt
```

## Alias `pt`

Com o alias `pt`, o painel pode ser aberto de qualquer diretório.

### Zsh

Na raiz deste repositório, execute uma vez:

```bash
printf "\nalias pt='%s/ping_test'\n" "$PWD" >> ~/.zshrc
source ~/.zshrc
```

Depois, abra o painel com:

```bash
pt
```

### Bash

Na raiz deste repositório, execute uma vez:

```bash
printf "\nalias pt='%s/ping_test'\n" "$PWD" >> ~/.bashrc
source ~/.bashrc
```

Depois, use:

```bash
pt
```

> Se o repositório for movido para outro caminho, atualize ou recrie o alias para apontar para a nova localização.

## Licença

Ainda não há uma licença definida. Antes de publicar no GitHub, escolha uma licença compatível com a forma como deseja distribuir o projeto.
