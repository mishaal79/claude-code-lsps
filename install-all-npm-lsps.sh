#!/bin/bash
# Install all npm-based LSP servers from mish-cc-market using bun
# Run this script to install all Node.js-based language servers in one command

set -e

echo "🚀 Installing all npm-based LSP servers using bun..."
echo ""

# TypeScript/JavaScript
echo "📦 Installing vtsls (TypeScript/JavaScript/React/SolidJS)..."
bun install -g @vtsls/language-server typescript

# Python (pyright alternative)
echo "📦 Installing pyright (Python alternative)..."
bun install -g pyright

# HTML/CSS
echo "📦 Installing emmet-language-server (HTML/CSS expansion)..."
bun add -g emmet-language-server

# Astro
echo "📦 Installing Astro language server..."
bun add -g typescript prettier prettier-plugin-astro @astrojs/language-server

# Svelte
echo "📦 Installing Svelte language server..."
bun add -g svelte-language-server

# TailwindCSS
echo "📦 Installing TailwindCSS language server..."
bun add -g @tailwindcss/language-server

# Bash/Shell
echo "📦 Installing bash-language-server..."
bun add -g bash-language-server

# YAML
echo "📦 Installing yaml-language-server..."
bun add -g yaml-language-server

# Biome (JS/TS/JSON/CSS unified)
echo "📦 Installing biome (unified JS/TS/JSON/CSS)..."
bun add -g @biomejs/biome

echo ""
echo "✅ All npm-based LSP servers installed successfully!"
echo ""
echo "📝 Note: This installs only Node.js-based LSPs. For other LSPs, see README.md:"
echo "   - Rust LSPs: cargo install (ty, pyrefly, markdown-oxide, taplo)"
echo "   - Go LSPs: go install (gopls, terraform-ls)"
echo "   - Native LSPs: rustup/apt/brew (rust-analyzer, clangd, superhtml)"
echo ""
echo "🔧 Next steps:"
echo "   1. Ensure bun's global bin is in your PATH"
echo "   2. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "   3. Verify installations: which vtsls (should show path)"
echo "   4. Install marketplace: /plugin marketplace add mishaal79/mish-claude-code-lsps"
echo "   5. Install plugins: /plugin install python@mish-cc-market (etc.)"
