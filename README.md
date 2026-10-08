# Ping Test (`pt`)

Uma ferramenta leve de diagnóstico de rede em Bash que abre um painel `tmux` com testes simultâneos de conectividade e rota para destinos públicos.

---

## ⚡ Funcionalidades

- **Painel em `tmux`**: abre quatro painéis de diagnóstico no terminal atual.
- **Testes de conectividade**: executa `ping` para `1.1.1.1`, `8.8.8.8` e `google.com`.
- **Rastreamento de rota**: executa `traceroute -n` para `8.8.8.8` (sem resolução reversa, mais rápido).
- **Layout otimizado**: usa todo o espaço disponível no terminal e remove a barra de status do `tmux`.
- **Reexecução segura**: substitui apenas a sessão chamada exatamente `pt`, inclusive quando executada de dentro dela.
- **Destinos configuráveis**: por variáveis de ambiente.
- **Verificação de dependências**: avisa claramente se `tmux`, `ping` ou `traceroute` estiverem ausentes.

---

## 📦 Dependências

Esta ferramenta requer `tmux`, `ping` e `traceroute`.

### Debian / Ubuntu / Kali / Pop!_OS

```bash
sudo apt update && sudo apt install -y tmux iputils-ping traceroute
```

### Arch Linux / Manjaro

```bash
sudo pacman -S tmux iputils traceroute
```

### Fedora

```bash
sudo dnf install tmux iputils traceroute
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
- avisa se `~/.local/bin` não estiver no `PATH`, ou se outro comando com o mesmo nome tiver prioridade.

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

| Variável | Padrão | Painel |
| :--- | :--- | :--- |
| `PT_PING_1` | `1.1.1.1` | Ping 1 |
| `PT_PING_2` | `8.8.8.8` | Ping 2 |
| `PT_PING_DNS` | `google.com` | Ping com resolução DNS |
| `PT_TRACE` | `8.8.8.8` | Traceroute |

### Encerrar ou desconectar da sessão

```bash
# Desconecte sem interromper os comandos: Ctrl+b, depois d

# Encerre a sessão e todos os seus painéis
tmux kill-session -t =pt
```

---

## 🛠️ Painéis executados

| Painel | Comando |
| :--- | :--- |
| Cloudflare DNS | `ping -c5 1.1.1.1` |
| Google DNS | `ping -c5 8.8.8.8` |
| Resolução DNS | `ping -c5 google.com` |
| Rota de rede | `traceroute -n 8.8.8.8` |

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
