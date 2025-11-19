---
project_name: "mish-cc-market"
description: "Performance-optimized LSP server marketplace for Claude Code"
marketplace_name: "mish-cc-market"
focus: "Rust/Go-based LSPs, frontend frameworks, modern tooling"
python_default_lsp: "ty"
---

# mish-cc-market Project Configuration

## Project Overview

This is a Claude Code marketplace providing performance-optimized Language Server Protocol (LSP) servers with a focus on:

- **Rust/Go-based implementations** for maximum performance
- **Frontend framework support** (Astro, Svelte, React, SolidJS)
- **Modern Python tooling** (ty, pyrefly, basedpyright)
- **Independent LSP servers** (no VS Code dependencies)

## Marketplace Installation

```bash
/plugin marketplace add mish-cc-market
```

## Development Workflow

### Adding New LSP Plugins

1. Research LSP server and verify independence
2. Create plugin directory: `<lsp-name>/`
3. Add `plugin.json` with metadata
4. Add `.lsp.json` with LSP configuration
5. Update README.md with installation instructions
6. Test plugin installation and LSP functionality

### Plugin Structure

Each LSP plugin follows this structure:

```
plugin-name/
├── plugin.json      # Metadata (name, description, repository, keywords)
└── .lsp.json        # LSP configuration (command, args, file extensions)
```

### LSP Configuration Template

**plugin.json:**
```json
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "Description of the LSP server",
  "author": {
    "name": "Mishal",
    "email": "mishal@qrius.global"
  },
  "repository": "https://github.com/org/repo",
  "license": "MIT",
  "keywords": ["language", "lsp", "language-server"]
}
```

**.lsp.json:**
```json
{
    "languageId": {
        "command": "lsp-command",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".ext": "languageId"
        },
        "transport": "stdio",
        "initializationOptions": {},
        "settings": {},
        "maxRestarts": 3
    }
}
```

## Current LSP Plugins

### Python (Default: ty)
- **python/** - ty (Astral, Rust, 26x faster)
- **python-pyright/** - pyright alternative
- **basedpyright/** - Pylance features
- **pyrefly/** - Meta's Rust LSP

### Frontend
- **vtsls/** - TypeScript/React/SolidJS
- **superhtml/** - HTML (Zig)
- **emmet-language-server/** - HTML/CSS expansion
- **astro-language-server/** - Astro support
- **svelte-language-server/** - Svelte support
- **tailwindcss-language-server/** - TailwindCSS

### Backend/Systems
- **rust-analyzer/** - Rust
- **gopls/** - Go
- **clangd/** - C/C++

### Other
- **bash-language-server/** - Shell
- **terraform-ls/** - Terraform
- **markdown-oxide/** - Markdown (PKM)
- **yaml-language-server/** - YAML
- **taplo/** - TOML
- **biome/** - JS/TS/JSON/CSS (unified)
- **oxc-language-server/** - JS/TS (Rust)

## Performance Priority

**Rust > Go > Native Binaries > Node.js/TypeScript**

Always prefer Rust or Go implementations when available.

## Plugin Development Resources

See `.claude/plugin-dev/` for:
- Hook development
- MCP integration
- Command creation
- Agent development
- Skill creation

## Validation Checklist

Before adding a new LSP:
- [ ] Verify LSP is actively maintained
- [ ] Check performance characteristics
- [ ] Ensure no VS Code dependencies
- [ ] Test with sample projects
- [ ] Document installation clearly
- [ ] Add to README.md
- [ ] Update marketplace description if needed
