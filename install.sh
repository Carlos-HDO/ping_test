#!/usr/bin/env bash
# Instala o ping_test em ~/.local/bin com os comandos `pt` e `pingtest`.
# Uso: ./install.sh [--force | --uninstall]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/ping_test"
TARGET_DIR="$HOME/.local/bin"
NAMES=(pt pingtest)

MODE="install"
case "${1:-}" in
    "") ;;
    --force) MODE="force" ;;
    --uninstall) MODE="uninstall" ;;
    -h|--help) sed -n '2,3s/^# //p' "$0"; exit 0 ;;
    *) echo "Opção inválida: $1 (use --help)" >&2; exit 1 ;;
esac

# Sucesso se o caminho for um link que aponta para este ping_test
is_ours() {
    [[ -L "$1" && "$(readlink -f "$1")" == "$(readlink -f "$SOURCE")" ]]
}

if [[ "$MODE" == "uninstall" ]]; then
    for name in "${NAMES[@]}"; do
        link="$TARGET_DIR/$name"
        if is_ours "$link"; then
            rm "$link"
            echo "Removido: $link"
        elif [[ -e "$link" || -L "$link" ]]; then
            echo "Ignorado (não pertence ao ping_test): $link"
        fi
    done
    exit 0
fi

# Numa worktree do git, .git é um arquivo; os links quebram quando ela for removida
if [[ -f "$SCRIPT_DIR/.git" ]]; then
    echo "⚠️  $SCRIPT_DIR é uma worktree do git: os links deixam de funcionar se ela for removida." >&2
    echo "   Prefira instalar a partir do checkout principal do repositório." >&2
fi

mkdir -p "$TARGET_DIR"
chmod +x "$SOURCE"

installed=()
for name in "${NAMES[@]}"; do
    link="$TARGET_DIR/$name"
    if [[ -e "$link" || -L "$link" ]] && ! is_ours "$link" && [[ "$MODE" != "force" ]]; then
        echo "⚠️  $link já existe e não aponta para o ping_test; ignorado (use --force para sobrescrever)." >&2
        continue
    fi
    ln -sfn "$SOURCE" "$link"
    installed+=("$name")
done

if (( ${#installed[@]} == 0 )); then
    echo "Nada foi instalado." >&2
    exit 1
fi

echo "✅ Instalado com sucesso!"
echo "Comandos disponíveis em $TARGET_DIR:"
for name in "${installed[@]}"; do
    echo "  • $name"
done

case ":$PATH:" in
    *":$TARGET_DIR:"*)
        # Avisa se outro comando com o mesmo nome vem antes no PATH
        for name in "${installed[@]}"; do
            resolved="$(type -P "$name" || true)"
            if [[ "$resolved" != "$TARGET_DIR/$name" ]]; then
                echo "⚠️  '$name' resolve para $resolved, que tem prioridade no PATH." >&2
            fi
        done
        ;;
    *)
        echo ""
        echo "⚠️  $TARGET_DIR não está no PATH. Adicione ao ~/.zshrc ou ~/.bashrc:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        ;;
esac
