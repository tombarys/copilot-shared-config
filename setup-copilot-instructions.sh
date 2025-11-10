#!/bin/bash

# Setup script pro GitHub Copilot instructions
# Vytvoří symlink v aktuálním projektu

set -e

echo "🔧 Nastavuji GitHub Copilot instructions pro projekt..."

# Zkontroluj, zda existuje centrální konfigurační soubor
COPILOT_CONFIG="$HOME/.config/copilot/copilot-instructions.md"
if [[ ! -f "$COPILOT_CONFIG" ]]; then
    echo "❌ Chyba: Centrální konfigurační soubor neexistuje: $COPILOT_CONFIG"
    echo "   Spusť nejprve: curl -sSL https://raw.githubusercontent.com/tombarys/copilot-shared-config/main/install.sh | bash"
    exit 1
fi

# Vytvoř .github adresář pokud neexistuje
mkdir -p .github

# Zkontroluj, zda už symlink existuje
SYMLINK_PATH=".github/copilot-instructions.md"
if [[ -L "$SYMLINK_PATH" ]]; then
    echo "⚠️  Symlink už existuje: $SYMLINK_PATH"
    echo "   Aktuální cíl: $(readlink "$SYMLINK_PATH")"
    read -p "   Přepsat? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   Zrušeno."
        exit 0
    fi
    rm "$SYMLINK_PATH"
elif [[ -f "$SYMLINK_PATH" ]]; then
    echo "⚠️  Soubor (ne symlink) už existuje: $SYMLINK_PATH"
    read -p "   Přepsat? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   Zrušeno."
        exit 0
    fi
    rm "$SYMLINK_PATH"
fi

# Vytvoř symlink
ln -s "$COPILOT_CONFIG" "$SYMLINK_PATH"

echo "✅ Hotovo! GitHub Copilot instructions nastaveny pro tento projekt."
echo "   Symlink: $SYMLINK_PATH -> $COPILOT_CONFIG"
echo ""
echo "💡 Tip: Pro editaci použij: code ~/.config/copilot/copilot-instructions.md"