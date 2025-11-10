# GitHub Copilot Shared Configuration

Tento repository obsahuje sdílenou konfiguraci pro GitHub Copilot instructions, která se dá synchronizovat mezi různými počítači a projekty.

## Rychlá instalace

```bash
curl -sSL https://raw.githubusercontent.com/tombarys/copilot-shared-config/main/install.sh | bash
```

## Ruční instalace

```bash
git clone https://github.com/tombarys/copilot-shared-config.git ~/.config/copilot
chmod +x ~/.config/copilot/setup-copilot-instructions.sh
```

## Použití v projektu

```bash
cd /path/to/vas-projekt
~/.config/copilot/setup-copilot-instructions.sh
```

## Struktura

- `copilot-instructions.md` - Hlavní konfigurační soubor
- `setup-copilot-instructions.sh` - Script pro nastavení symlinků v projektech
- `install.sh` - Instalační script pro nové počítače
- `README.md` - Tato dokumentace

## Editace

Vždy edituj pouze centrální soubor:

```bash
code ~/.config/copilot/copilot-instructions.md
```

Změny se automaticky projeví ve všech projektech díky symlinkům.

## Synchronizace

### Stažení změn

```bash
cd ~/.config/copilot
git pull
```

### Poslání změn

```bash
cd ~/.config/copilot
git add .
git commit -m "Update copilot instructions"
git push
```
