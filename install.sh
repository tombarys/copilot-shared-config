#!/bin/bash

# Instalační script pro GitHub Copilot shared config
# Stáhne a nastaví sdílenou konfiguraci

set -e

echo "🚀 Instaluji GitHub Copilot shared config..."

# Vytvoř konfigurační adresář
CONFIG_DIR="$HOME/.config/copilot"
mkdir -p "$CONFIG_DIR"

# Zkontroluj, zda už není nastaveno
if [[ -d "$CONFIG_DIR/.git" ]]; then
    echo "⚠️  Git repository už existuje v $CONFIG_DIR"
    echo "   Pro aktualizaci spusť: cd $CONFIG_DIR && git pull"
    exit 0
fi

# Klonuj repository
cd "$CONFIG_DIR"
git init
git remote add origin https://github.com/tombarys/copilot-shared-config.git
git branch -m main

echo "📥 Stahuji konfiguraci z GitHub..."
git pull origin main

# Nastav práva na scripty
chmod +x setup-copilot-instructions.sh

echo "✅ Instalace dokončena!"
echo ""
echo "📋 Další kroky:"
echo "   1. Přejdi do svého projektu: cd /path/to/projekt"
echo "   2. Spusť setup: ~/.config/copilot/setup-copilot-instructions.sh"
echo ""
echo "📝 Pro editaci instrukcí: code ~/.config/copilot/copilot-instructions.md"