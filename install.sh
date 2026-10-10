#!/usr/bin/env bash
# Installs ping_test into ~/.local/bin as the `pt` and `pingtest` commands.
# Usage: ./install.sh [--force | --uninstall]

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
    *) echo "Invalid option: $1 (see --help)" >&2; exit 1 ;;
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
            echo "Removed: $link"
        elif [[ -e "$link" || -L "$link" ]]; then
            echo "Skipped (not owned by ping_test): $link"
        fi
    done
    exit 0
fi

# Numa worktree do git, .git é um arquivo; os links quebram quando ela for removida
if [[ -f "$SCRIPT_DIR/.git" ]]; then
    echo "⚠️  $SCRIPT_DIR is a git worktree: the links will break if it is removed." >&2
    echo "   Prefer installing from the main checkout of the repository." >&2
fi

mkdir -p "$TARGET_DIR"
chmod +x "$SOURCE"

installed=()
for name in "${NAMES[@]}"; do
    link="$TARGET_DIR/$name"
    if [[ -e "$link" || -L "$link" ]] && ! is_ours "$link" && [[ "$MODE" != "force" ]]; then
        echo "⚠️  $link already exists and does not point to ping_test; skipped (use --force to overwrite)." >&2
        continue
    fi
    ln -sfn "$SOURCE" "$link"
    installed+=("$name")
done

if (( ${#installed[@]} == 0 )); then
    echo "Nothing was installed." >&2
    exit 1
fi

echo "✅ Installed successfully!"
echo "Commands available in $TARGET_DIR:"
for name in "${installed[@]}"; do
    echo "  • $name"
done

case ":$PATH:" in
    *":$TARGET_DIR:"*)
        # Avisa se outro comando com o mesmo nome vem antes no PATH
        for name in "${installed[@]}"; do
            resolved="$(type -P "$name" || true)"
            if [[ "$resolved" != "$TARGET_DIR/$name" ]]; then
                echo "⚠️  '$name' resolves to $resolved, which takes precedence in PATH." >&2
            fi
        done
        ;;
    *)
        echo ""
        echo "⚠️  $TARGET_DIR is not in PATH. Add this to ~/.zshrc or ~/.bashrc:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        ;;
esac
