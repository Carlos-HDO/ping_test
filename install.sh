#!/usr/bin/env bash
# Installation script for ping_test utility in ~/.local/bin

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/bin"
BIN_NAME="pt"

mkdir -p "$TARGET_DIR"

chmod +x "$SCRIPT_DIR/ping_test"

ln -sf "$SCRIPT_DIR/ping_test" "$TARGET_DIR/$BIN_NAME"
ln -sf "$SCRIPT_DIR/ping_test" "$TARGET_DIR/pingtest"

echo "✅ Successfully installed!"
echo "Available commands in $TARGET_DIR:"
echo "  • $BIN_NAME"
echo "  • pingtest"
echo ""
echo "Ensure '$TARGET_DIR' is included in your PATH."
