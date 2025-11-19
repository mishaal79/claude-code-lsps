# mish-cc-market

This repository contains a [Claude Code marketplace](https://code.claude.com/docs/en/plugin-marketplaces) with plugins that offer **performance-optimized LSP servers** for TypeScript, Rust, Python, Go, Java, C/C++, PHP, Ruby, C#, HTML, CSS, Astro, Svelte, TailwindCSS, Shell, Terraform, Markdown, YAML, TOML, and JSON. [LSP servers](https://microsoft.github.io/language-server-protocol) provide powerful and familiar code intelligence features to IDEs, and now Claude Code directly.

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
2. `/plugin marketplace add mish-cc-market`

Then enable the plugins of your choice:
1. Run `claude`
2. Type `/plugins`
3. Choose `Browse and install plugins`
4. Enter the `mish-cc-market` marketplace
5. Select the plugins you'd like with the spacebar (e.g. TypeScript, Rust, Python)
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
bun install -g @vtsls/language-server typescript
```

**Framework Support**: This LSP provides full support for:
- **React** (including React 19) - JSX/TSX autocomplete, type checking, and IntelliSense
- **SolidJS** - JSX/TSX with proper `jsxImportSource` handling
- **Preact, Qwik, and other JSX frameworks** - Complete TypeScript/JSX integration

Make sure the `vtsls` executable is in your PATH.

</details>

<details>
<summary>Python (<code>ty</code>) ⚡ RUST - DEFAULT</summary>

Install **ty** - Astral's extremely fast Python type checker and language server:
```bash
# Using uv (recommended)
uv tool install ty

# Using pip
pip install ty
```

**Performance**: 26x faster than pyright (0.5s vs 13.6s on 100k LOC). Written in Rust by Astral (creators of Ruff and uv) for optimal speed.

**This is the default Python LSP** in this marketplace. The `ty` executable needs to be in your PATH.

</details>

<details>
<summary>Python - basedpyright (<code>basedpyright</code>)</summary>

Install **basedpyright** - community fork of pyright with Pylance features:
```bash
# Using pipx (recommended)
pipx install basedpyright

# Using pip
pip install basedpyright
```

**Features**: Includes Pylance-exclusive features like semantic highlighting and inlay hints. Improved type checking with better handling of `Any` type and inherited attributes. Default language server in Zed editor.

The `basedpyright-langserver` executable needs to be in your PATH.

</details>

<details>
<summary>Python - pyright (<code>pyright</code>) - ALTERNATIVE</summary>

Install **pyright** for its speed and excellent type checking:
```bash
bun install -g pyright
```

Alternative Python LSP option. The `pyright-langserver` executable needs to be in your PATH.

</details>

<details>
<summary>Python - pyrefly (<code>pyrefly</code>) ⚡ RUST</summary>

Install **pyrefly** - Meta's lightning-fast Python type checker and language server:
```bash
# Using cargo
cargo install pyrefly

# Or download pre-built binaries from releases
# https://github.com/facebook/pyrefly/releases
```

**Performance**: Type checks 1.85 million lines of code per second. Written in Rust for optimal speed and IDE responsiveness. Designed from day one as both a type checker and language server.

**Status**: Active alpha with weekly releases from Meta. Replaces the retired Pyre type checker.

The `pyrefly` executable needs to be in your PATH.

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
<summary>HTML (<code>superhtml</code>) ⚡ ZIG</summary>

Install **superhtml** - first HTML LSP with full syntax error reporting:
```bash
# Download pre-built binary from releases
# https://github.com/kristoff-it/superhtml/releases

# Or build from source with Zig
zig build -Doptimize=ReleaseSafe
```

**Features**: First-ever HTML Language Server that reports syntax errors. Validates element nesting, attribute values, and implements the full HTML5 spec. Includes formatter and templating support.

The `superhtml` executable needs to be in your PATH.

</details>

<details>
<summary>Emmet (<code>emmet-language-server</code>)</summary>

Install **emmet-language-server** - modern HTML/CSS expansion with JSX/TSX support:
```bash
bun add -g emmet-language-server
```

**Features**: Emmet abbreviation expansion for HTML, CSS, SCSS, SASS, Less, JSX, TSX, Vue, and Svelte. Essential for frontend development.

The `emmet-language-server` executable needs to be in your PATH.

</details>

<details>
<summary>Astro (<code>astro-language-server</code>)</summary>

Install **@astrojs/language-server** - official Astro language server:
```bash
bun add -g typescript prettier prettier-plugin-astro @astrojs/language-server
```

**Features**: Full IDE support for .astro files including diagnostics, autocomplete, formatting, and code navigation.

The `astro-ls` executable needs to be in your PATH.

</details>

<details>
<summary>Svelte (<code>svelte-language-server</code>)</summary>

Install **svelte-language-server** - official Svelte language server:
```bash
bun add -g svelte-language-server
```

**Features**: Full language server support for .svelte files including diagnostics, autocomplete, hover, and formatting.

The `svelteserver` executable needs to be in your PATH.

</details>

<details>
<summary>TailwindCSS (<code>tailwindcss-language-server</code>)</summary>

Install **@tailwindcss/language-server** - official Tailwind IntelliSense:
```bash
bun add -g @tailwindcss/language-server
```

**Features**: Class autocomplete, linting, and hover previews for Tailwind CSS. Works with HTML, JSX, TSX, Vue, Svelte, and Astro files. Requires `tailwind.config.js` in your workspace.

The `tailwindcss-language-server` executable needs to be in your PATH.

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
<summary>JavaScript/TypeScript/JSON/CSS - biome (<code>biome</code>) ⚡ RUST</summary>

Install **biome** - lightning-fast Rust-based unified toolchain:
```bash
bun add -g @biomejs/biome
```

**Performance**: Extremely fast Rust implementation. Unified formatter, linter, and LSP for JavaScript, TypeScript, JSON, and CSS.

Provides a single tool for multiple languages with exceptional performance.

</details>
