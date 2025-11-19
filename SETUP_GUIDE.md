# 🚀 Claude Code LSP Setup Guide

Complete setup instructions for using the performance-optimized LSP marketplace.

---

## ✅ **Prerequisites**

1. Claude Code 2.0.30+ installed
2. Git installed
3. Basic package managers (npm/cargo/brew) depending on which LSP servers you want

---

## 📦 **Step 1: Apply TweakCC Patches**

This fixes bugs in Claude Code's LSP support.

```bash
# Install and apply tweakcc patches
npx tweakcc --apply
```

**What this does:**
- Fixes LSP server startup issues
- Makes automatic LSP launching work properly
- Improves communication between Claude and LSP servers

---

## 🔧 **Step 2: Enable LSP Tool**

Add the environment variable to your shell configuration:

```bash
# For zsh (macOS default)
echo 'export ENABLE_LSP_TOOL=1' >> ~/.zshrc
source ~/.zshrc

# For bash (Linux default)
echo 'export ENABLE_LSP_TOOL=1' >> ~/.bashrc
source ~/.bashrc

# Verify it's set
echo $ENABLE_LSP_TOOL
# Should print: 1
```

**Important:** This must be set in your shell, not in Claude Code settings!

---

## 🎯 **Step 3: Add Plugin Marketplace**

```bash
# Start Claude Code
claude

# Add the marketplace
/plugin marketplace add mishaal79/claude-code-lsps

# Expected output:
# ✓ Marketplace added successfully
```

---

## 📥 **Step 4: Install LSP Plugins**

```bash
# In Claude Code, run:
/plugins

# You'll see a menu:
# 1. Browse and install plugins
# 2. Manage installed plugins
# 3. Update plugins

# Select "Browse and install plugins"
# Navigate to "Claude Code Language Servers" marketplace
# Use SPACEBAR to select the plugins you want:

# ⚡ Recommended (Performance-Optimized Rust/Go):
# [x] ty (Python - Rust, 26x faster)
# [x] oxc-language-server (JS/TS - Rust, 50-100x faster)
# [x] markdown-oxide (Markdown - Rust, PKM features)
# [x] terraform-ls (Terraform - Go, optimized)
# [x] taplo (TOML - Rust)
# [x] biome (JS/TS/JSON/CSS - Rust unified toolchain)

# 📦 Traditional (Still excellent):
# [x] vtsls (TypeScript/JavaScript)
# [x] pyright (Python - alternative to ty)
# [x] rust-analyzer (Rust)
# [x] gopls (Go)
# [x] bash-language-server (Shell scripts)
# [x] yaml-language-server (YAML)

# Press 'i' to install selected plugins
# Restart Claude Code when prompted
```

---

## 💿 **Step 5: Install Actual LSP Server Executables**

**The plugins are just configurations!** You must install the actual LSP servers:

### **Python - ty (Recommended)** ⚡ RUST
```bash
# Using uv (recommended)
uv tool install ty

# Or using pip
pip install ty
```

### **JavaScript/TypeScript - oxc (Recommended)** ⚡ RUST
```bash
# Using npm
npm install -g oxlint

# Plugin will use: npx -y --package=oxlint -c oxc_language_server
```

### **JavaScript/TypeScript - biome (Unified Toolchain)** ⚡ RUST
```bash
# Using npm
npm install -g @biomejs/biome

# Or using bun
bun add -g @biomejs/biome
```

### **Markdown - markdown-oxide (Recommended)** ⚡ RUST
```bash
# Using cargo
cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide

# Or using cargo-binstall (faster)
cargo binstall --git 'https://github.com/feel-ix-343/markdown-oxide' markdown-oxide
```

### **Terraform - terraform-ls** ⚡ GO
```bash
# macOS/Linux with Homebrew
brew install hashicorp/tap/terraform-ls

# Or download from: https://releases.hashicorp.com/terraform-ls/
```

### **TOML - taplo** ⚡ RUST
```bash
# Using cargo (requires --features lsp flag)
cargo install --features lsp --locked taplo-cli
```

### **Shell - bash-language-server**
```bash
# Using npm
npm install -g bash-language-server

# Or using bun
bun add -g bash-language-server
```

### **YAML - yaml-language-server**
```bash
# Using npm
npm install -g yaml-language-server

# Or using bun
bun add -g yaml-language-server
```

### **TypeScript/JavaScript - vtsls (Traditional)**
```bash
# Using npm
npm install -g @vtsls/language-server typescript

# Or using bun
bun add -g @vtsls/language-server typescript
```

### **Python - pyright (Traditional alternative)**
```bash
# Using npm
npm install -g pyright

# Or using bun
bun add -g pyright
```

### **Rust - rust-analyzer**
```bash
# If you have rustup
rustup component add rust-analyzer
```

### **Go - gopls**
```bash
# Using go install
go install golang.org/x/tools/gopls@latest

# Add Go bin to PATH if needed
export PATH="$PATH:$(go env GOPATH)/bin"
```

---

## 🧠 **Step 6: Add System Prompt (Highly Recommended)**

Make Claude proactive about using LSP tools:

```bash
# Create or edit ~/.claude/CLAUDE.md
cat >> ~/.claude/CLAUDE.md << 'EOF'

## LSP Tool Usage Protocol

### ALWAYS Use LSP First

When navigating code, prioritize LSP operations:
- "where is X defined?" → LSP goToDefinition
- "find all uses of X" → LSP findReferences
- "what's the type of X?" → LSP hover
- "show file structure" → LSP documentSymbol
- "search symbols" → LSP workspaceSymbol

### Available High-Performance Servers

⚡ **Rust-based (Ultra Fast)**:
- Python: `ty` (26x faster than pyright)
- JS/TS: `oxc` (50-100x faster than ESLint)
- Markdown: `markdown-oxide` (PKM features, backlinks)
- TOML: `taplo` (minimal memory)
- Multi: `biome` (JS/TS/JSON/CSS unified)

⚡ **Go-based (Optimized)**:
- Terraform: `terraform-ls` (99% memory reduction)
- Go: `gopls` (official Go tool)

### Proactive LSP Usage

Before modifying code:
1. Use `findReferences` to understand impact
2. Use `goToDefinition` to check implementation
3. Use `hover` to verify types and contracts

### Priority Order

1. ✅ Try LSP operation FIRST (if server available)
2. ⚠️ Fallback to Grep if LSP unavailable
3. ❌ Use Read + manual search only as last resort

### Graceful Degradation

If LSP operation fails:
- Log the failure (don't hide it)
- Explain fallback strategy to user
- Use Grep or Read as alternative

EOF
```

---

## ✅ **Step 7: Verify Setup**

```bash
# Restart Claude Code
claude

# Test LSP awareness with these queries:
"Use LSP to find the definition of useState in this React file"
"Show me all references to formatDate using LSP"
"Use hover to check the type of this variable"

# Monitor LSP activity (in another terminal)
tail -f ~/.claude/debug.txt | grep -i lsp

# Check running LSP servers
ps aux | grep -E "vtsls|ty|oxc_language_server|terraform-ls|markdown-oxide"
```

---

## 🎯 **Quick Start Commands (Copy-Paste Ready)**

### **Minimal Setup (Core Tools)**
```bash
# 1. Patches and environment
npx tweakcc --apply
echo 'export ENABLE_LSP_TOOL=1' >> ~/.zshrc && source ~/.zshrc

# 2. Add marketplace and install plugins
claude
# Then run these in Claude Code:
# /plugin marketplace add mishaal79/claude-code-lsps
# /plugins

# 3. Install essential LSP servers
npm install -g @vtsls/language-server typescript
uv tool install ty
npm install -g oxlint
```

### **Full Setup (All Performance-Optimized Servers)**
```bash
# 1. Patches and environment
npx tweakcc --apply
echo 'export ENABLE_LSP_TOOL=1' >> ~/.zshrc && source ~/.zshrc

# 2. Install all Rust/Go LSP servers
uv tool install ty
npm install -g oxlint
npm install -g @biomejs/biome
cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide
brew install hashicorp/tap/terraform-ls
cargo install --features lsp --locked taplo-cli
npm install -g bash-language-server
npm install -g yaml-language-server

# 3. Add marketplace and install all plugins
claude
# Then: /plugin marketplace add mishaal79/claude-code-lsps
# Then: /plugins (select all)

# 4. Add system prompt
cat >> ~/.claude/CLAUDE.md << 'EOF'
## LSP Tool Usage Protocol
### ALWAYS Use LSP First
- "where is X?" → LSP goToDefinition
- "find uses" → LSP findReferences
- "type info" → LSP hover
### Priority: LSP > Grep > Read
EOF
```

---

## 🐛 **Troubleshooting**

### **LSP not working?**

```bash
# 1. Check environment variable
echo $ENABLE_LSP_TOOL
# Should print: 1

# 2. Verify LSP server is installed
which ty
which oxc_language_server
which terraform-ls

# 3. Check Claude Code debug logs
tail -f ~/.claude/debug.txt | grep -i lsp

# 4. Verify tweakcc patches applied
npx tweakcc --status

# 5. Restart Claude Code completely
pkill -f claude && claude
```

### **LSP server not found?**

```bash
# Ensure executables are in PATH
echo $PATH

# For Rust tools
export PATH="$HOME/.cargo/bin:$PATH"

# For Go tools
export PATH="$PATH:$(go env GOPATH)/bin"

# For npm global tools
npm config get prefix  # Should be in PATH
```

### **No UI indication of LSP status?**

This is normal! Claude Code 2.0.30 has no UI for LSP status. You must:
- Check debug logs: `tail -f ~/.claude/debug.txt | grep -i lsp`
- Check running processes: `ps aux | grep -E "vtsls|ty|gopls"`
- Test with explicit LSP queries in Claude

---

## 📊 **What You Get**

After setup, you'll have:

✅ **19 LSP Server Plugins** available
✅ **6 Rust-based servers** (26-100x faster)
✅ **2 Go-based servers** (optimized)
✅ **Automatic LSP server startup** (via tweakcc)
✅ **Intelligent LSP usage** (via system prompt)
✅ **Code navigation** (goToDefinition, findReferences, hover)
✅ **Graceful fallbacks** (Grep → Read)

---

## 🎓 **Next Steps**

1. **Test with real projects**: Open a TypeScript/Python/Rust project
2. **Ask Claude to navigate**: "Find the definition of this function"
3. **Monitor performance**: Compare LSP vs Grep search speeds
4. **Customize prompts**: Add project-specific LSP usage patterns

---

## 📚 **Resources**

- **Marketplace Repo**: https://github.com/mishaal79/claude-code-lsps
- **TweakCC**: https://github.com/Piebald-AI/tweakcc
- **Claude Code Docs**: https://code.claude.com/docs
- **LSP Specification**: https://microsoft.github.io/language-server-protocol

---

## 🆘 **Support**

If you encounter issues:
1. Check debug logs: `~/.claude/debug.txt`
2. Verify setup steps completed
3. Open issue at: https://github.com/mishaal79/claude-code-lsps/issues

---

**Enjoy blazing fast code navigation with performance-optimized LSP servers!** 🚀
