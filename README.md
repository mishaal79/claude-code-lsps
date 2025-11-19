# Claude Code LSPs

This repository contains a [Claude Code marketplace](https://code.claude.com/docs/en/plugin-marketplaces) with plugins that offer **performance-optimized LSP servers** for TypeScript, Rust, Python, Go, Java, C/C++, PHP, Ruby, C#, HTML/CSS, Shell, Terraform, Markdown, YAML, TOML, and JSON. [LSP servers](https://microsoft.github.io/language-server-protocol) provide powerful and familiar code intelligence features to IDEs, and now Claude Code directly.

**⚡ Performance Focus**: This marketplace prioritizes **Rust** and **Go** based LSP servers for maximum speed and minimal memory usage. Rust/Go implementations are typically 3-100x faster than TypeScript/Node.js alternatives.

[**Claude Code is going to officially support LSP soon.**](https://www.reddit.com/r/ClaudeAI/comments/1otdfo9/lsp_is_coming_to_claude_code_and_you_can_try_it)  In 2.0.30 (October 31st) they adding the working beginnings of a system to run LSP servers from plugins automatically on startup, and an `LSP` tool (enable via `$ENABLE_LSP_TOOL=1`) that Claude can use to
- Go to the definition for symbols (`goToDefinition`)
- Hover over symbols (`hover`)
- List all the symbols in a file (`documentSymbol`)
- Find all references to a symbol (`findReferences`)
- Search for symbols across the workspace (`workspaceSymbol`)

> [!warning]
> Support for LSP in Claude Code is pretty raw still.  There are bugs in the different LSP operations, no documention, and no UI indication that your LSP servers are started/running/have errors or even exist.  But it's there, and with [tweakcc](https://github.com/Piebald-AI/tweakcc) you can make it work.

## Patching Claude Code

You can manually patch it, but it's much easier to use [tweakcc](https://github.com/Piebald-AI/tweakcc) to automatically detect your Claude Code installation (npm or native) apply the necessary patches.

Run `npx tweakcc --apply`.  It will automatically patch your Claude Code installation to make LSP support usable.  (It also does a bunch of other things like let you customize all the system prompt parts, create new CC themes, change the thinking verbs, and a lot more.)

If you'd like to apply the patches yourself, go the bottom of this page.

## Installing the plugins

Install them the usual way.  First make CC aware of the marketplace:
1. Run `claude`
2. `/plugin marketplace add Piebald-AI/claude-code-lsps`

Then enable the plugins of your choice:
1. Run `claude`
2. Type `/plugins`
3. Choose `Browse and install plugins`
4. Enter the `Claude Code Language Servers` marketplace
5. Select the plugins you'd like with the spacebar (e.g. TypeScript, Rust)
6. Press "i" to install them
7. Restart Claude Code

Here's a screenshot:

<img width="603" height="374" alt="image" src="https://github.com/user-attachments/assets/207ebb79-8c45-446b-9c08-eb81d235c301" />


## Language-specific setup instructions

You need to install various components in order for the plugins to use them:

<details>
<summary>Rust (<code>rust-analyzer</code>)</summary>

Uses `rust-analyzer`, the official modern Rust Language Server and the same one used by the official VS Code extension.  If you have `rustup`, installing `rust-analyzer` is easy:

```bash
rustup component add rust-analyzer
```

The `rust-analyzer` executable needs to be in your PATH.

</details>

<details>
<summary>JavaScript/TypeScript (<code>vtsls</code>)</summary>

Install **vtsls** and `typescript` packages globally:
```bash
# npm
npm install -g @vtsls/language-server typescript

# pnpm
pnpm install -g @vtsls/language-server typescript

# bun
bun install -g @vtsls/language-server typescript
```
Make sure the `vtsls` executable is in your PATH.

</details>

<details>
<summary>Python (<code>pyright</code>)</summary>

Install **pyright** for its speed and excellent type checking:
```bash
# npm
npm install -g pyright

# pnpm
pnpm install -g pyright

# bun
bun install -g pyright
```

</details>

<details>
<summary>Go (<code>gopls</code>)</summary>

Install **gopls**, the official Go language server:
```bash
go install golang.org/x/tools/gopls@latest
```
Make sure your Go bin directory is in your PATH (usually `~/go/bin`).

</details>

<details>
<summary>Java (<code>jdtls</code>)</summary>

Install **Eclipse JDT Language Server** (jdtls). Requires Java 21+ runtime:
```bash
# Download from official sources
# Latest snapshot:
curl -LO http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz
mkdir -p ~/jdtls
tar -xzf jdt-language-server-latest.tar.gz -C ~/jdtls

# Or install via package manager (varies by OS)
# macOS with Homebrew:
brew install jdtls
```

Set `JAVA_HOME` environment variable to Java 21+ installation.

</details>

<details>
<summary>C/C++ (<code>clangd</code>)</summary>

Install **clangd**, the official LLVM-based language server:
```bash
# macOS
brew install llvm

# Ubuntu/Debian
sudo apt-get install clangd

# Arch Linux
sudo pacman -S clang

# Or download from LLVM releases
# https://github.com/clangd/clangd/releases
```

</details>

<details>
<summary>PHP (<code>phpactor</code>)</summary>

Install **Phpactor**:
```bash
# Using composer (recommended)
composer global require phpactor/phpactor

# Or using package manager
# macOS with Homebrew:
brew install phpactor/tap/phpactor
```

Ensure `~/.composer/vendor/bin` (or `~/.config/composer/vendor/bin` on some systems) is in your PATH.

</details>

<details>
<summary>Ruby (<code>ruby-lsp</code>)</summary>

Install **ruby-lsp**:
```bash
gem install ruby-lsp
```

</details>

<details>
<summary>C# (<code>omnisharp</code>)</summary>

Install **OmniSharp** (requires .NET SDK):
```bash
# macOS with Homebrew:
brew install omnisharp/omnisharp-roslyn/omnisharp-mono

# Or download from releases:
# https://github.com/OmniSharp/omnisharp-roslyn/releases

# Extract and add to PATH, or use the install script:
# Linux/macOS:
curl -L https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-linux-x64-net6.0.tar.gz | tar xz -C ~/.local/bin

# Ensure the OmniSharp executable is in your PATH
```

</details>

<details>
<summary>HTML/CSS (<code>vscode-langservers</code>)</summary>

Install **vscode-langservers-extracted** for both HTML and CSS:
```bash
# npm
npm install -g vscode-langservers-extracted

# pnpm
pnpm install -g vscode-langservers-extracted

# bun
bun install -g vscode-langservers-extracted
```

This provides `vscode-html-language-server` and `vscode-css-language-server` executables.

</details>

<details>
<summary>Python - ty (<code>ty</code>) ⚡ RUST</summary>

Install **ty** - extremely fast Python type checker by Astral (creators of Ruff):
```bash
# Using uv (recommended)
uv tool install ty

# Using pip
pip install ty
```

**Performance**: 26x faster than pyright (0.5s vs 13.6s on 100k LOC). Written in Rust for optimal speed.

The `ty` executable needs to be in your PATH.

</details>

<details>
<summary>JavaScript/TypeScript - oxc (<code>oxc-language-server</code>) ⚡ RUST</summary>

Install **oxlint** package which includes the oxc language server:
```bash
# npm
npm install -g oxlint

# Or use npx without installation
npx --yes oxlint
```

**Performance**: 50-100x faster than ESLint, 3x faster than SWC. Only 11.5MB memory footprint. Written in Rust.

The plugin uses `npx` to run `oxc_language_server` from the oxlint package automatically.

</details>

<details>
<summary>Bash/Shell (<code>bash-language-server</code>)</summary>

Install **bash-language-server** for shell script support:
```bash
# npm
npm install -g bash-language-server

# pnpm
pnpm install -g bash-language-server

# bun
bun add -g bash-language-server
```

Supports `.sh`, `.bash`, and `.zsh` files.

</details>

<details>
<summary>Terraform (<code>terraform-ls</code>) ⚡ GO</summary>

Install **terraform-ls** - official HashiCorp Terraform language server:
```bash
# macOS/Linux (Homebrew)
brew install hashicorp/tap/terraform-ls

# Or download binary from releases
# https://releases.hashicorp.com/terraform-ls/
```

**Performance**: 99% reduction in memory usage (v0.34+). Ensure you have the latest version for optimal performance.

The `terraform-ls` executable needs to be in your PATH.

</details>

<details>
<summary>Markdown (<code>markdown-oxide</code>) ⚡ RUST</summary>

Install **markdown-oxide** - blazing fast Rust-based PKM Markdown language server:
```bash
# Using cargo
cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide

# Or using cargo-binstall (faster, downloads pre-built binary)
cargo binstall --git 'https://github.com/feel-ix-343/markdown-oxide' markdown-oxide
```

**Features**: PKM (Personal Knowledge Management) with backlinks, references, daily notes, and cross-file linking. Lighter and faster than marksman.

Supports `.md`, `.markdown`, and `.mdx` files.

</details>

<details>
<summary>YAML (<code>yaml-language-server</code>)</summary>

Install **yaml-language-server** for YAML file support:
```bash
# npm
npm install -g yaml-language-server

# pnpm
pnpm install -g yaml-language-server

# bun
bun add -g yaml-language-server
```

Provides validation, auto-completion, and schema support for YAML files.

</details>

<details>
<summary>TOML (<code>taplo</code>) ⚡ RUST</summary>

Install **taplo** - TOML language server:
```bash
# Using cargo (requires --features lsp flag)
cargo install --features lsp --locked taplo-cli
```

**Performance**: Rust-based for minimal memory usage and fast parsing. Excellent for Cargo.toml and other TOML configs.

The `taplo` executable needs to be in your PATH.

</details>

<details>
<summary>JSON (<code>vscode-json-languageserver</code>)</summary>

Install **vscode-langservers-extracted** which includes the JSON language server:
```bash
# npm
npm install -g vscode-langservers-extracted

# pnpm
pnpm install -g vscode-langservers-extracted

# bun
bun add -g vscode-langservers-extracted
```

Provides IntelliSense, validation, and schema support for JSON and JSONC files.

</details>

<details>
<summary>JavaScript/TypeScript/JSON/CSS - biome (<code>biome</code>) ⚡ RUST</summary>

Install **biome** - lightning-fast Rust-based unified toolchain:
```bash
# npm
npm install -g @biomejs/biome

# pnpm
pnpm install -g @biomejs/biome

# bun
bun add -g @biomejs/biome
```

**Performance**: Extremely fast Rust implementation. Unified formatter, linter, and LSP for JavaScript, TypeScript, JSON, and CSS.

Provides a single tool for multiple languages with exceptional performance.

</details>
