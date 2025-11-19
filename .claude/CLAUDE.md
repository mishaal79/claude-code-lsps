# Claude Code Marketplace & Plugin System Documentation

## Key Concepts

### Marketplace vs Plugin

**Marketplace** (this repository)
- A JSON catalog file at `.claude-plugin/marketplace.json`
- Lists all available plugins with metadata
- Users add marketplaces once, then install individual plugins from it
- Can be hosted on any Git service (GitHub, GitLab, etc.)

**Plugin** (individual directories like `python/`, `rust-analyzer/`, etc.)
- A directory containing:
  - `plugin.json` - Metadata (name, description, author, keywords)
  - `.lsp.json` - LSP server configuration (command, args, file extensions)
- Each plugin provides a specific LSP server integration
- Installed from a marketplace catalog

### This Is A Marketplace

This repository (`mish-claude-code-lsps`) IS a marketplace that contains 24 LSP server plugins.

## Installation Flow

### Step 1: Add Marketplace (One Time)

Users add this marketplace to Claude Code:

```bash
# In Claude Code CLI
/plugin marketplace add mishaal79/mish-claude-code-lsps
```

This reads `.claude-plugin/marketplace.json` and makes all 24 plugins discoverable.

### Step 2: Install Plugins (As Needed)

Users then install specific plugins they want:

```bash
# Install Python LSP (ty, the default)
/plugin install python@mish-cc-market

# Install Rust LSP
/plugin install rust-analyzer@mish-cc-market

# Install frontend LSPs
/plugin install astro-language-server@mish-cc-market
/plugin install svelte-language-server@mish-cc-market
/plugin install tailwindcss-language-server@mish-cc-market
```

### Step 3: LSP Auto-Start

Once installed, Claude Code automatically:
1. Reads the plugin's `.lsp.json` configuration
2. Starts the LSP server when opening matching file types
3. Provides code intelligence (autocomplete, diagnostics, etc.)

## File Structure

###marketplace.json Structure

```json
{
  "name": "mish-cc-market",
  "owner": {
    "name": "Mishal",
    "email": "mishal@qrius.global"
  },
  "metadata": {
    "description": "Performance-optimized LSP servers",
    "version": "2.0.0"
  },
  "plugins": [
    {
      "name": "python",
      "version": "0.1.0",
      "source": "./python",
      "description": "Python LSP using ty",
      "category": "development",
      "tags": ["python", "lsp", "rust"],
      "author": {
        "name": "Mishal",
        "email": "mishal@qrius.global"
      }
    }
    // ... 23 more plugins
  ]
}
```

**Key Fields:**
- `name` - Marketplace identifier (kebab-case)
- `owner` - Maintainer information
- `plugins` - Array of plugin entries
- Each plugin has `source` pointing to its directory

### Plugin Structure

Each plugin directory contains TWO files:

**1. plugin.json** (Metadata)
```json
{
  "name": "python",
  "version": "0.1.0",
  "description": "Rust-based Python type checker",
  "author": {
    "name": "Mishal",
    "email": "mishal@qrius.global"
  },
  "repository": "https://github.com/astral-sh/ty",
  "license": "MIT",
  "keywords": ["python", "lsp", "rust", "ty"]
}
```

**2. .lsp.json** (LSP Configuration)
```json
{
  "python": {
    "command": "ty",
    "args": ["server"],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    },
    "transport": "stdio",
    "initializationOptions": {},
    "settings": {},
    "maxRestarts": 3
  }
}
```

**LSP Configuration Fields:**
- `command` - Executable name (must be in PATH)
- `args` - Command-line arguments
- `extensionToLanguage` - Map file extensions to language IDs
- `transport` - Communication method (always "stdio")
- `maxRestarts` - Max automatic restarts on crash

## Repository Structure

```
mish-claude-code-lsps/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog (24 plugins)
├── .claude/
│   ├── CLAUDE.md                 # This documentation
│   ├── PLUGIN_DEVELOPMENT.md     # Plugin development guide
│   ├── mish-cc-market.local.md   # Project configuration
│   └── plugin-dev/               # Plugin development toolkit
├── python/                       # Plugin: ty (default Python LSP)
│   ├── plugin.json
│   └── .lsp.json
├── python-pyright/               # Plugin: pyright (alternative)
│   ├── plugin.json
│   └── .lsp.json
├── rust-analyzer/                # Plugin: Rust LSP
│   ├── plugin.json
│   └── .lsp.json
├── ... (21 more plugin directories)
└── README.md                     # Installation instructions
```

## How Claude Code Uses This

1. **Marketplace Discovery**
   - User runs: `/plugin marketplace add mishaal79/mish-claude-code-lsps`
   - Claude Code fetches `.claude-plugin/marketplace.json`
   - Reads all 24 plugin entries

2. **Plugin Installation**
   - User runs: `/plugin install python@mish-cc-market`
   - Claude Code reads `marketplace.json` to find `source: "./python"`
   - Clones/copies the `python/` directory
   - Reads `python/plugin.json` and `python/.lsp.json`

3. **LSP Server Startup**
   - User opens a `.py` file
   - Claude Code checks `extensionToLanguage` mapping
   - Finds `.py` maps to `python` language ID
   - Runs: `ty server` (from `.lsp.json` command + args)
   - Communicates via stdio

4. **Code Intelligence**
   - LSP server provides:
     - Autocomplete
     - Type checking
     - Go to definition
     - Find references
     - Hover information
   - All powered by the LSP server (ty, in this case)

## Available Plugins (24 Total)

### Python (4 options)
- **python** - ty (Astral/Rust, DEFAULT, 26x faster)
- **python-pyright** - pyright (alternative)
- **basedpyright** - Pylance features
- **pyrefly** - Meta/Rust (1.85M LOC/sec)

### Frontend (6 plugins)
- **vtsls** - TypeScript/JavaScript/React/SolidJS
- **superhtml** - HTML (Zig-based)
- **emmet-language-server** - HTML/CSS expansion
- **astro-language-server** - Astro
- **svelte-language-server** - Svelte
- **tailwindcss-language-server** - TailwindCSS

### Backend Languages (7 plugins)
- **rust-analyzer** - Rust
- **gopls** - Go
- **jdtls** - Java
- **clangd** - C/C++
- **phpactor** - PHP
- **ruby-lsp** - Ruby
- **omnisharp** - C#

### Tools & Config (7 plugins)
- **bash-language-server** - Shell scripts
- **terraform-ls** - Terraform/HCL
- **markdown-oxide** - Markdown (PKM)
- **yaml-language-server** - YAML
- **taplo** - TOML
- **biome** - JS/TS/JSON/CSS (unified)
- **oxc-language-server** - JS/TS (Rust)

## Performance Philosophy

**Priority Order: Rust > Go > Native Binaries > Node.js/TypeScript**

This marketplace prioritizes:
- ⚡ Rust-based LSPs (ty, pyrefly, markdown-oxide, taplo, biome, oxc)
- ⚡ Go-based LSPs (gopls, terraform-ls)
- ⚡ Native binaries (rust-analyzer, clangd, superhtml)
- Node.js only when necessary (vtsls, astro, svelte, tailwind)

**Why?**
- Rust/Go: 3-100x faster, minimal memory
- Native: Optimal performance
- Node.js: Good ecosystem, but slower

## Common Questions

### Q: How do users find available plugins?
A: After adding the marketplace, they run `/plugins` and browse the marketplace section.

### Q: Can users install multiple Python LSPs?
A: Yes, but only one will be active per project. They can switch in settings.

### Q: Do LSP servers need to be installed separately?
A: Yes! The plugins only configure LSP integration. Users must install the actual LSP executables (via npm, cargo, apt, brew, etc.). See README.md for installation commands.

### Q: What if an LSP server isn't in PATH?
A: Claude Code will show an error. Users need to ensure the executable is accessible (add to PATH or use absolute path in .lsp.json).

### Q: Can this marketplace be used with teams?
A: Yes! Teams can configure `.claude/settings.json` to auto-install this marketplace and specific plugins.

## Updating the Marketplace

When adding new plugins:

1. Create plugin directory with `plugin.json` and `.lsp.json`
2. Add entry to `.claude-plugin/marketplace.json`
3. Update README.md with installation instructions
4. Commit and push to GitHub
5. Users will see the new plugin next time they browse

Claude Code automatically fetches the latest marketplace.json when users browse plugins.

## References

- [Official Plugin Marketplaces Docs](https://code.claude.com/docs/en/plugin-marketplaces)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)

## Development

See `.claude/PLUGIN_DEVELOPMENT.md` for comprehensive plugin development guide including:
- Creating new LSP plugins
- Testing LSP configurations
- Best practices
- Common patterns
- Troubleshooting

## License

MIT - See individual LSP projects for their licenses.
