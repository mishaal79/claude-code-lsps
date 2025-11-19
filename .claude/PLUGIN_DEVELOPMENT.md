# Plugin Development Guide for mish-cc-market

## Overview

This guide explains how to develop LSP plugins for the **mish-cc-market** Claude Code marketplace.

## Prerequisites

- Claude Code 2.0.30+ installed
- Git for cloning LSP repositories
- Node.js/npm (for Node-based LSPs)
- Rust/Cargo (for Rust-based LSPs)
- Go (for Go-based LSPs)

## Plugin Development Toolkit

The **plugin-dev** toolkit is installed in `.claude/plugin-dev/` and provides:

### 7 Core Skills

1. **Hook Development** - Event-driven automation
2. **MCP Integration** - Model Context Protocol servers
3. **Plugin Structure** - Directory layouts and manifests
4. **Plugin Settings** - Configuration management
5. **Command Development** - Slash commands
6. **Agent Development** - Autonomous agents
7. **Skill Development** - Creating new skills

### Access Plugin-Dev

```bash
# Via slash command in Claude Code
/plugin-dev:create-plugin

# Read documentation
cat .claude/plugin-dev/README.md
cat .claude/plugin-dev/skills/*/SKILL.md
```

## Creating a New LSP Plugin

### Step 1: Research the LSP

Before adding an LSP, verify:

- ✅ **Active Maintenance** - Recent commits, active issues
- ✅ **Independence** - No VS Code dependencies
- ✅ **Performance** - Prefer Rust > Go > Native > Node.js
- ✅ **Official or Well-Maintained** - From framework authors or trusted maintainers
- ✅ **Clear Installation** - Easy to install globally

### Step 2: Create Plugin Directory

```bash
cd /path/to/mish-claude-code-lsps
mkdir <lsp-name>
cd <lsp-name>
```

### Step 3: Create plugin.json

```json
{
  "name": "lsp-name",
  "version": "0.1.0",
  "description": "Brief description with key features",
  "author": {
    "name": "Mishal",
    "email": "mishal@qrius.global"
  },
  "repository": "https://github.com/org/lsp-repo",
  "license": "MIT",
  "keywords": ["language", "lsp", "language-server", "keyword1", "keyword2"]
}
```

**Keywords Guide:**
- Language name(s)
- "lsp" and "language-server"
- Performance tags: "rust", "go", "fast", "performance"
- Framework/tool names
- Special features

### Step 4: Create .lsp.json

```json
{
    "languageId": {
        "command": "lsp-executable-name",
        "args": ["--stdio"],
        "extensionToLanguage": {
            ".ext": "languageId",
            ".ext2": "languageId"
        },
        "transport": "stdio",
        "initializationOptions": {},
        "settings": {},
        "maxRestarts": 3
    }
}
```

**Field Explanations:**

- **languageId**: LSP language identifier (e.g., "python", "javascript", "html")
- **command**: Executable command in PATH
- **args**: Command-line arguments (usually `["--stdio"]` or `["lsp"]`)
- **extensionToLanguage**: Map file extensions to language IDs
- **transport**: Always "stdio" for now
- **initializationOptions**: LSP-specific init options (usually empty)
- **settings**: LSP-specific settings (usually empty)
- **maxRestarts**: Max restart attempts (always 3)

### Step 5: Update README.md

Add a new section in the appropriate location:

```markdown
<details>
<summary>Language (<code>lsp-name</code>) ⚡ RUST</summary>

Install **lsp-name** - description:
\`\`\`bash
# Installation method 1
npm install -g lsp-package

# Installation method 2 (if applicable)
cargo install lsp-package

# Installation method 3 (if applicable)
brew install lsp-package
\`\`\`

**Performance**: Performance notes if Rust/Go-based
**Features**: Key features and capabilities

The \`lsp-executable\` needs to be in your PATH.

</details>
```

**Section Ordering:**
1. Rust ⚡ RUST
2. JavaScript/TypeScript
3. Python
4. Go
5. Frontend (HTML, CSS, Astro, Svelte, etc.)
6. Backend languages (Java, C/C++, PHP, Ruby, C#)
7. Shell/Scripting
8. Config/Data (Terraform, Markdown, YAML, TOML, JSON)
9. Unified tools (Biome, oxc)

### Step 6: Test the Plugin

```bash
# 1. Verify files are created
ls -la <lsp-name>/

# 2. Check JSON syntax
cat <lsp-name>/plugin.json | jq .
cat <lsp-name>/.lsp.json | jq .

# 3. Test installation command
npm install -g <package-name>  # or cargo/brew

# 4. Verify executable is in PATH
which <lsp-executable>

# 5. Test LSP manually (if applicable)
<lsp-executable> --version
```

## Plugin Structure Examples

### Minimal Plugin (Rust-based)

```
rust-analyzer/
├── plugin.json      # Metadata
└── .lsp.json        # LSP config with "rust-analyzer" command
```

### Standard Plugin (Node-based)

```
vtsls/
├── plugin.json      # Metadata
└── .lsp.json        # LSP config with "vtsls" command
```

### Multi-Language Plugin

```
emmet-language-server/
├── plugin.json      # Metadata for Emmet
└── .lsp.json        # Supports .html, .css, .jsx, .tsx, etc.
```

## Best Practices

### DO ✅

- **Prefer Rust/Go** implementations for speed
- **Test thoroughly** before committing
- **Document clearly** with installation commands
- **Use semantic keywords** in plugin.json
- **Follow naming conventions** (lowercase with hyphens)
- **Verify PATH requirements** in README
- **Check LSP compatibility** with Claude Code
- **Keep descriptions concise** but informative

### DON'T ❌

- **Avoid VS Code dependencies** (vscode-langservers-extracted, etc.)
- **Don't skip testing** installation commands
- **Don't use vague descriptions** ("A language server")
- **Don't forget performance notes** for Rust/Go
- **Don't add unmaintained** LSPs
- **Don't duplicate functionality** (check existing plugins)

## Common LSP Commands and Args

| LSP | Command | Args |
|-----|---------|------|
| rust-analyzer | `rust-analyzer` | `[]` |
| gopls | `gopls` | `[]` |
| pyright | `pyright-langserver` | `["--stdio"]` |
| vtsls | `vtsls` | `["--stdio"]` |
| clangd | `clangd` | `[]` |
| bash-language-server | `bash-language-server` | `["start"]` |
| terraform-ls | `terraform-ls` | `["serve"]` |
| astro-ls | `astro-ls` | `["--stdio"]` |
| svelteserver | `svelteserver` | `["--stdio"]` |
| superhtml | `superhtml` | `["lsp"]` |
| emmet-language-server | `emmet-language-server` | `["--stdio"]` |

## File Extension to Language ID Mapping

Common mappings:

```json
{
  ".js": "javascript",
  ".jsx": "javascriptreact",
  ".ts": "typescript",
  ".tsx": "typescriptreact",
  ".py": "python",
  ".pyi": "python",
  ".rs": "rust",
  ".go": "go",
  ".html": "html",
  ".css": "css",
  ".scss": "scss",
  ".astro": "astro",
  ".svelte": "svelte",
  ".vue": "vue",
  ".md": "markdown",
  ".yaml": "yaml",
  ".yml": "yaml",
  ".toml": "toml",
  ".json": "json",
  ".sh": "sh",
  ".bash": "bash",
  ".tf": "terraform"
}
```

## Troubleshooting

### LSP Not Starting

1. Check executable is in PATH: `which <lsp-command>`
2. Verify JSON syntax: `cat .lsp.json | jq .`
3. Test LSP manually: `<lsp-command> --version`
4. Check Claude Code logs

### LSP Crashing

1. Verify `maxRestarts: 3` in .lsp.json
2. Check LSP version compatibility
3. Test with minimal project
4. Check LSP-specific requirements (config files, etc.)

### Autocomplete Not Working

1. Verify `extensionToLanguage` mappings
2. Check language ID matches LSP expectations
3. Ensure project has proper config files
4. Test with known-working file

## Version Control

### .gitignore Considerations

Already configured in `.claude/.gitignore`:
```
*.local.md
plugin-dev/
```

### Committing Changes

```bash
# Stage new plugin
git add <lsp-name>/

# Stage README updates
git add README.md

# Commit with descriptive message
git commit -m "Add <lsp-name> LSP plugin for <language>"

# Push to repository
git push
```

## Resources

- **Plugin-Dev Docs**: `.claude/plugin-dev/README.md`
- **Claude Code Docs**: https://code.claude.com/docs
- **LSP Specification**: https://microsoft.github.io/language-server-protocol/
- **Project Config**: `.claude/mish-cc-market.local.md`

## Support

For issues or questions:
- Check existing plugin examples in this repo
- Review plugin-dev skills in `.claude/plugin-dev/skills/`
- Consult Claude Code documentation
- Test with minimal examples first
