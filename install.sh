#!/bin/zsh
# Bootstrap script — installs Nix then applies the nix-darwin flake.
# Everything else (homebrew, packages, dotfiles, macOS defaults) is
# declared in config/nix/ and applied by `darwin-rebuild switch`.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
FLAKE="$ROOT"
HOSTNAME="${HOSTNAME:-deathstar}"

# ── 1. Xcode Command Line Tools ───────────────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Re-run this script after the installer finishes."
    exit 0
fi

# ── 2. Nix (Determinate Systems installer) ────────────────────────────────────
if ! command -v nix &>/dev/null; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L \
        https://install.determinate.systems/nix | sh -s -- install
    # Source nix into this session
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# ── 3. nix-darwin ─────────────────────────────────────────────────────────────
if ! command -v darwin-rebuild &>/dev/null; then
    echo "Bootstrapping nix-darwin..."
    nix run nix-darwin -- switch --flake "$FLAKE#$HOSTNAME"
else
    echo "Applying nix-darwin configuration..."
    darwin-rebuild switch --flake "$FLAKE#$HOSTNAME"
fi

echo "Done! Open a new shell to pick up the environment."
