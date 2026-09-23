# Ping Test (`pt`)

Uma ferramenta leve de diagnóstico de rede em Bash que abre um painel `tmux` com testes simultâneos de conectividade e rota para destinos públicos.

---

## ⚡ Funcionalidades

- **Painel em `tmux`**: abre quatro painéis de diagnóstico no terminal atual.
- **Testes de conectividade**: executa `ping` para `1.1.1.1`, `8.8.8.8` e `google.com`.
- **Rastreamento de rota**: executa `traceroute` para `8.8.8.8`.
- **Layout otimizado**: usa todo o espaço disponível no terminal e remove a barra de status do `tmux`.
- **Reexecução segura**: encerra uma sessão anterior chamada `pt` antes de criar uma nova.

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

## 🚀 Uso e exemplos

Torne o script executável, se necessário:

```bash
chmod +x ping_test
```

### Uso básico

```bash
# Execute a partir da raiz do repositório
./ping_test

# Ou use o alias global, após configurá-lo
pt
```

### Encerrar ou desconectar da sessão

```bash
# Desconecte sem interromper os comandos: Ctrl+b, depois d

# Encerre a sessão e todos os seus painéis
tmux kill-session -t pt
```

---

## 🛠️ Painéis executados

| Painel | Comando |
| :--- | :--- |
| Cloudflare DNS | `ping -c5 1.1.1.1` |
| Google DNS | `ping -c5 8.8.8.8` |
| Resolução DNS | `ping -c5 google.com` |
| Rota de rede | `traceroute 8.8.8.8` |

---

## 🔗 Atalho global no shell (alias)

Para executar a ferramenta de qualquer diretório com o comando simples `pt`, adicione um alias ao seu `~/.zshrc` ou `~/.bashrc`:

```bash
# Ajuste o caminho para a pasta onde você clonou o repositório
alias pt="$HOME/path/to/ping_test/ping_test"
```

Depois de salvar o alias, recarregue a configuração do shell:

```bash
# Para Zsh
source ~/.zshrc

# Para Bash
source ~/.bashrc
```

Com isso, execute o painel em qualquer diretório:

```bash
pt
```

> Se o repositório for movido para outro caminho, atualize o alias para apontar para a nova localização.

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
