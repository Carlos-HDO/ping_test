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
- **Reexecução segura**: substitui apenas a sessão chamada exatamente `pt`, inclusive quando executada de dentro dela.
- **Destinos configuráveis** por variáveis de ambiente.

---

## 📦 Dependências

- **Obrigatórias**: `tmux`, `ping` e `traceroute` **ou** `tracepath`.
- **Opcionais**: `dig` (teste com DNS externo) e `curl` (teste HTTP). Sem elas, o painel correspondente avisa o que instalar.

### Debian / Ubuntu / Kali / Pop!_OS

```bash
sudo apt update && sudo apt install -y tmux iputils-ping traceroute dnsutils curl
```

### Arch Linux / Manjaro

```bash
sudo pacman -S tmux iputils traceroute bind curl
```

### Fedora

```bash
sudo dnf install tmux iputils traceroute bind-utils curl
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
| `PT_TRACE` | `8.8.8.8` | Rota |
| `PT_LAT_SLOW` | `60` | Latência média (ms) acima da qual o ping é "um pouco lento" |
| `PT_LAT_VERY_SLOW` | `150` | Latência média (ms) acima da qual o ping é "muito lento" |
| `PT_JITTER` | `30` | Variação (ms) acima da qual a latência é considerada oscilante |

### Encerrar ou desconectar da sessão

```bash
# Desconecte sem interromper os comandos: Ctrl+b, depois d

# Encerre a sessão e todos os seus painéis
tmux kill-session -t =pt
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
| Rota | `traceroute -n 8.8.8.8` (ou `tracepath -n`) |

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

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
