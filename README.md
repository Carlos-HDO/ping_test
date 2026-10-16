# Ping Test (`pt`)

Uma ferramenta leve de diagnóstico de rede em Bash que abre um painel `tmux` com testes simultâneos e aponta **onde** está o problema: rede local, provedor, DNS ou acesso web.

---

## ⚡ Funcionalidades

- **Painel em `tmux`**: seis painéis em grade, cada um identificado por título na borda.
- **Gateway local**: detectado automaticamente (IPv4 ou IPv6); separa falha no Wi-Fi/cabo de falha no provedor.
- **Conectividade**: `ping` para `1.1.1.1` e `8.8.8.8`, avaliando perda de pacotes, latência média e oscilação (jitter): aponta quando a internet funciona, mas está lenta ou instável.
- **DNS**: compara o resolvedor do sistema com um DNS externo (`@1.1.1.1`) e distingue resolvedor quebrado, DNS bloqueado e nome inexistente.
- **HTTP/HTTPS**: funciona mesmo onde ICMP é bloqueado e detecta portal cativo ou proxy interceptando.
- **Rota**: `traceroute -n` ou, na falta dele, `tracepath -n` (não exige root).
- **Vereditos**: todos os painéis, exceto o de rota, terminam com uma conclusão (✅ OK, ⚠️ funcionando com problemas, ❌ falha).
- **Dicas de correção**: cada falha ou alerta termina com `💡 Most likely fix`, a causa mais provável e os comandos para resolver (em inglês). Dependências ausentes mostram o comando de instalação da sua distribuição (apt, pacman, dnf, zypper ou apk).
- **Reexecução segura**: substitui apenas a sessão chamada exatamente `pt`, inclusive quando executada de dentro dela.
- **Modo avançado (`-a`)**: abre mais duas abas no `tmux`, com sinal Wi-Fi/cabo, IPv6, MTU, velocidade do DNS, portas bloqueadas, perda por salto (MTR), CGNAT, velocidade e bufferbloat.
- **Destinos configuráveis** por variáveis de ambiente.
- **Mensagens em inglês**: a saída da ferramenta (painéis, vereditos, `--help` e instalador) é exibida em inglês.

---

## 📦 Dependências

- **Obrigatórias**: `tmux`, `ping` e `traceroute` **ou** `tracepath`.
- **Opcionais**: `dig` (teste com DNS externo) e `curl` (teste HTTP); no modo avançado, também `mtr`. Sem elas, o painel correspondente mostra o comando de instalação.

### Debian / Ubuntu / Kali / Pop!_OS

```bash
sudo apt update && sudo apt install -y tmux iputils-ping traceroute dnsutils curl mtr
```

### Arch Linux / Manjaro

```bash
sudo pacman -S tmux iputils traceroute bind curl mtr
```

### Fedora

```bash
sudo dnf install tmux iputils traceroute bind-utils curl mtr
```

---

## 📥 Instalação

```bash
git clone https://github.com/Carlos-HDO/ping_test.git
cd ping_test
./install.sh
```

O instalador cria os links `pt` e `pingtest` em `~/.local/bin`, apontando para o script do repositório (por isso, mantenha o repositório no lugar ou reinstale após movê-lo). Ele também:

- **não sobrescreve** comandos `pt`/`pingtest` já existentes que não sejam do ping_test (use `./install.sh --force` para sobrescrever);
- avisa se `~/.local/bin` não estiver no `PATH`, ou se outro comando com o mesmo nome tiver prioridade;
- avisa se for executado a partir de uma worktree do git, cujos links quebram quando ela é removida.

Se necessário, adicione `~/.local/bin` ao `PATH` no `~/.zshrc` ou `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Para desinstalar (remove apenas os links que apontam para o ping_test):

```bash
./install.sh --uninstall
```

---

## 🚀 Uso e exemplos

### Uso básico

```bash
pt              # após a instalação
./ping_test     # ou direto da raiz do repositório
pt -a           # modo avançado: abas extras com testes mais completos
pt --help       # mostra destinos e opções
```

Ao terminar, cada painel abre a sua shell (`$SHELL`). Executar `pt` novamente, inclusive de dentro de um dos painéis, recria a sessão com novos testes.

### Destinos personalizados

```bash
PT_PING_1=192.168.0.1 PT_TRACE=example.com pt
```

| Variável | Padrão | Uso |
| :--- | :--- | :--- |
| `PT_GATEWAY` | detectado via `ip route` (ou `/proc/net/route`) | Gateway local; defina se não for detectado |
| `PT_PING_1` | `1.1.1.1` | Ping 1 |
| `PT_PING_2` | `8.8.8.8` | Ping 2 |
| `PT_PING_DNS` | `google.com` | Nome consultado no painel DNS |
| `PT_DNS_SERVER` | `1.1.1.1` | DNS externo de comparação |
| `PT_HTTP_URL` | `https://www.cloudflare.com` | Teste HTTPS |
| `PT_PORTAL_URL` | `http://connectivitycheck.gstatic.com/generate_204` | Detecção de portal cativo (espera HTTP 204) |
| `PT_TRACE` | `8.8.8.8` | Route |
| `PT_LAT_SLOW` | `60` | Latência média (ms) acima da qual o ping é "a bit slow" |
| `PT_LAT_VERY_SLOW` | `150` | Latência média (ms) acima da qual o ping é "very slow" |
| `PT_JITTER` | `30` | Variação (ms) acima da qual a latência é considerada oscilante |
| `PT_SPEED_SECONDS` | `8` | Duração (s) de cada sentido do teste de velocidade no modo `-a`; `0` desativa a aba |
| `PT_SPEED_DELAY` | `30` | Espera (s) antes do teste de velocidade, para não distorcer os outros painéis (Enter inicia na hora) |

### Rolar o histórico de um painel

A sessão `pt` liga o mouse do `tmux`: a roda rola o histórico do painel sob o cursor, e o clique seleciona o painel. Para selecionar texto com o mouse, segure **Shift**. Sem mouse, use `Ctrl+b [`, role com as setas ou PgUp/PgDn e saia com `q`.

No `tmux` 3.6 ou mais novo, cada painel também ganha uma barra de rolagem lateral. Nas versões anteriores ela não existe, e o resto funciona igual.

### Encerrar ou desconectar da sessão

```bash
# Desconecte sem interromper os comandos: Ctrl+b, depois d

# Encerre a sessão e todos os seus painéis
tmux kill-session -t '=pt'   # aspas: no zsh, =pt vira o caminho do comando pt
```

---

## 🛠️ Painéis executados

| Painel | O que faz |
| :--- | :--- |
| Gateway | `ping -c5` no gateway padrão |
| Ping 1.1.1.1 | `ping -c5 1.1.1.1` + resumo de perda, latência e oscilação |
| Ping 8.8.8.8 | `ping -c5 8.8.8.8` + resumo de perda, latência e oscilação |
| DNS | `getent hosts` (sistema) × `dig @1.1.1.1` (externo) + `ping -c3` por nome |
| HTTP | `curl` em HTTPS + verificação de portal cativo |
| Route | `traceroute -n 8.8.8.8` (ou `tracepath -n`) |

### Modo avançado (`pt -a`)

Além da aba `basic`, abre mais duas abas. Para alternar entre elas, use `Ctrl+b n` (próxima) e `Ctrl+b p` (anterior).

| Aba | Painel | O que faz |
| :--- | :--- | :--- |
| `advanced` | Interface | Sinal do Wi-Fi (dBm, canal, banda) ou velocidade negociada no cabo, e taxa de erros da interface |
| | Public IP / IPv6 | IP público e país; detecta IPv6 ausente ou quebrado (endereço sem rota) |
| | MTU | MTU do caminho até `PT_PING_1` por busca binária; aponta PPPoE, VPN ou túnel |
| | DNS speed | Tempo de resposta do DNS do sistema (o upstream real, não o cache `127.0.0.53`) × 1.1.1.1, 8.8.8.8 e 9.9.9.9 |
| | Ports | Portas TCP de saída (53, 853, 80, 443, 22, 587, 993, 25) e QUIC/HTTP3; detecta firewall |
| | MTR | Perda por salto até `PT_TRACE`, indicando se começa no roteador, no provedor ou além; detecta CGNAT e NAT duplo |
| `speed` | Speed and bufferbloat | Download e upload (4 conexões, speed.cloudflare.com) e o aumento da latência sob carga, com nota de A+ a F |

> O teste de velocidade consome dados: até algumas centenas de MB em conexões rápidas. Em redes limitadas, use `PT_SPEED_SECONDS=0 pt -a`.

### Dicas de correção

Quando um painel conclui com ❌ ou ⚠️, ele imprime a solução mais provável com os comandos prontos para copiar:

```text
❌ System DNS failed, but the external one responds: problem with the configured resolver (...).

💡 Most likely fix: the configured resolver is broken or stale; restart it and flush its cache, or switch to a public DNS.
     $ resolvectl status   # shows which DNS server each interface uses
     $ sudo systemctl restart systemd-resolved && sudo resolvectl flush-caches
```

No painel HTTP a dica depende do erro do `curl`: falha de DNS, certificado/relógio, ou conexão recusada/proxy. Os comandos assumem `NetworkManager` e `systemd-resolved` (o padrão em Debian, Ubuntu, Fedora e derivadas); em outros sistemas, adapte-os.

### Como ler o resultado

| Sintoma | Provável causa |
| :--- | :--- |
| Gateway ❌ | Rede local: Wi-Fi, cabo, roteador ou DHCP |
| Gateway ✅, pings ❌ | Provedor de internet |
| Pings ⚠️ lenta/oscilando | Congestionamento: Wi-Fi fraco, rede local ocupada (downloads, streaming) ou provedor sobrecarregado; se o gateway também estiver lento, o problema é local |
| Pings ⚠️ perdendo pacotes | Conexão instável: sinal Wi-Fi, cabo ou provedor |
| Pings ✅, DNS ❌ (externo responde) | Resolvedor configurado (roteador ou `/etc/resolv.conf`) |
| Pings ❌, HTTP ✅ | ICMP bloqueado na rede; a internet funciona |
| HTTP ❌ com resposta inesperada | Portal cativo (Wi-Fi público/hotel) ou proxy |
| MTR: perda só em saltos intermediários | Roteadores limitando respostas ICMP; não é perda real |
| Bufferbloat C ou pior | Roteador sem controle de fila: ative SQM/QoS (fq_codel ou CAKE) |
| CGNAT detectado | Sem IPv4 público: redirecionamento de portas não funciona |

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
