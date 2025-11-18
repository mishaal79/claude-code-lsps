# Claude Code LSPs - Project Context

## Project Overview

**Type:** Claude Code Plugin Marketplace
**Purpose:** Provide LSP (Language Server Protocol) integrations for 10 programming languages
**Architecture:** Configuration-only marketplace with zero source code
**Owner:** QRIUS (support@qrius.global)

This repository is a **declarative plugin marketplace** that bridges Claude Code with industry-standard LSP servers. It contains no implementation code—only JSON configuration files that tell Claude Code how to invoke and communicate with external LSP servers.

---

## Core Principles

### 1. Configuration Over Code

This project follows a **declarative configuration pattern**:

- **No TypeScript/JavaScript/Python source files**
- **No build process or compilation**
- **No npm dependencies or package.json**
- **Pure JSON configuration** defining LSP server integrations

**Why?** Minimal surface area for bugs, maximum simplicity, and reliance on battle-tested upstream LSP servers.

### 2. Thin Wrapper Philosophy

Each plugin is a **thin configuration wrapper** around an existing, mature LSP server:

```
Plugin ≠ LSP Implementation
Plugin = Configuration pointing to upstream LSP server
```

**Examples:**
- `vtsls` plugin → Points to upstream `@vtsls/language-server` (maintained by yioneko)
- `rust-analyzer` plugin → Points to upstream `rust-analyzer` (official Rust LSP)
- `pyright` plugin → Points to upstream `pyright` (Microsoft's Python LSP)

### 3. Separation of Concerns

**Plugin Repository Responsibility:**
- Declare how to invoke LSP servers
- Define file extension mappings
- Specify communication protocol (stdio)
- Document installation requirements

**Upstream LSP Server Responsibility:**
- Implement Language Server Protocol
- Handle language-specific intelligence
- Maintain backward compatibility
- Provide language features (hover, goto definition, etc.)

**User Responsibility:**
- Install LSP servers globally (npm, cargo, apt, brew, etc.)
- Ensure executables are in PATH
- Configure language-specific settings if needed

---

## Repository Structure

```
claude-code-lsps/
├── .claude-plugin/
│   └── marketplace.json          # Central registry (single source of truth)
├── [language-name]/               # 10 language directories
│   ├── plugin.json                # Plugin metadata (author, version, description)
│   └── .lsp.json                  # LSP server configuration (command, args, extensions)
└── README.md                      # User-facing documentation
```

### File Purposes

**`.claude-plugin/marketplace.json`**
- Defines marketplace name and owner
- Lists all available plugins with metadata
- Single source of truth for plugin discovery
- Used by Claude Code's `/plugin marketplace add` command

**`[language]/plugin.json`**
- Plugin metadata visible in Claude Code UI
- Author information, version, description
- Repository link to upstream LSP server
- License and keywords for discoverability

**`[language]/.lsp.json`**
- LSP server invocation configuration
- File extension to language mappings
- Transport protocol (stdio)
- Server-specific initialization options

---

## Supported Languages

| Language | Plugin | Upstream LSP Server | Maintainer |
|----------|--------|-------------------|------------|
| TypeScript/JavaScript | `vtsls` | [@vtsls/language-server](https://github.com/yioneko/vtsls) | yioneko |
| Rust | `rust-analyzer` | [rust-analyzer](https://github.com/rust-lang/rust-analyzer) | Rust Team |
| Python | `pyright` | [pyright](https://github.com/microsoft/pyright) | Microsoft |
| Go | `gopls` | [gopls](https://github.com/golang/tools/tree/master/gopls) | Go Team |
| Java | `jdtls` | [Eclipse JDT.LS](https://github.com/eclipse-jdtls/eclipse.jdt.ls) | Eclipse |
| C/C++ | `clangd` | [clangd](https://github.com/clangd/clangd) | LLVM |
| Ruby | `ruby-lsp` | [ruby-lsp](https://github.com/Shopify/ruby-lsp) | Shopify |
| HTML/CSS | `vscode-langservers` | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) | hrsh7th |
| PHP | `phpactor` | [phpactor](https://github.com/phpactor/phpactor) | Phpactor Team |
| C# | `omnisharp` | [OmniSharp](https://github.com/OmniSharp/omnisharp-roslyn) | OmniSharp Team |

---

## LSP Capabilities Provided

All plugins expose these Language Server Protocol operations to Claude Code:

| Operation | Purpose | Example Use Case |
|-----------|---------|------------------|
| `goToDefinition` | Jump to symbol definition | Navigate to function/class implementation |
| `hover` | Show documentation on hover | View type signatures, docstrings |
| `documentSymbol` | List all symbols in file | Outline view, symbol navigation |
| `findReferences` | Find all usages of symbol | Refactoring, impact analysis |
| `workspaceSymbol` | Search symbols across workspace | Find classes/functions project-wide |

**Note:** Capabilities depend on upstream LSP server implementation quality. Some servers provide additional features (diagnostics, code actions, formatting) that Claude Code may support in future versions.

---

## Development Workflow

### Making Changes

This project has **three types of valid changes**:

#### 1. **Version Bumps** (Ownership/Breaking Changes)
When changing ownership, contact information, or making breaking changes:
- Bump all plugin versions in `.claude-plugin/marketplace.json` (10 plugins)
- Bump all plugin versions in individual `plugin.json` files (10 files)
- Use semantic versioning: `0.x.0` for breaking changes, `0.0.x` for patches

#### 2. **Adding New Language Plugins**
To add a new language:

```bash
# 1. Create plugin directory
mkdir [language-name]

# 2. Create plugin.json
cat > [language-name]/plugin.json <<EOF
{
  "name": "[language-name]",
  "version": "0.1.0",
  "description": "[Description]",
  "author": {
    "name": "QRIUS",
    "email": "support@qrius.global"
  },
  "repository": "[upstream-lsp-repo-url]",
  "license": "[License]",
  "keywords": ["[lang]", "lsp", "language-server"]
}
EOF

# 3. Create .lsp.json (see examples in existing plugins)

# 4. Add entry to .claude-plugin/marketplace.json

# 5. Document installation in README.md
```

**Criteria for Adding Languages:**
- ✅ Mature, actively maintained upstream LSP server exists
- ✅ LSP server installable via common package managers
- ✅ LSP server executable can run as standalone process
- ✅ Documented installation procedure
- ❌ Experimental or unmaintained LSP servers
- ❌ LSP servers requiring complex IDE integration

#### 3. **Updating LSP Server Configurations**
To fix bugs or improve LSP server invocation:
- Modify `.lsp.json` files (command, args, settings)
- Test changes locally before committing
- Document breaking changes in commit messages

### Testing Changes Locally

```bash
# 1. Remove existing marketplace (if installed)
claude
/plugin marketplace remove qrius/claude-code-lsps

# 2. Add local development version
/plugin marketplace add file:///absolute/path/to/claude-code-lsps

# 3. Install plugins and test
/plugins
# Browse → Install → Restart Claude Code

# 4. Verify LSP operations work
# - Open a file in the target language
# - Test hover, goto definition, find references
# - Check Claude Code logs for LSP errors
```

### Validation Checklist

Before committing changes:

- [ ] All `plugin.json` files have consistent `author` information
- [ ] All `plugin.json` files have consistent version numbers (if bumping)
- [ ] `.claude-plugin/marketplace.json` versions match individual `plugin.json` versions
- [ ] All JSON files are valid (use `jq . < file.json` to validate)
- [ ] README.md updated if adding/removing languages
- [ ] README.md installation instructions tested
- [ ] No hardcoded absolute paths in `.lsp.json` files
- [ ] LSP server executables referenced by name (not full paths)

---

## Branding and Ownership

**Current Ownership:** QRIUS (qrius/claude-code-lsps)
**Previous Ownership:** Piebald LLC (Piebald-AI/claude-code-lsps)

### Branding Consistency Points

These locations contain branding information and must stay synchronized:

1. **`.claude-plugin/marketplace.json`**
   - Line 3-6: `owner.name` and `owner.email`
   - Lines 21-24, 36-39, etc.: Each plugin's `author.name` and `author.email`

2. **Individual `plugin.json` files (10 total)**
   - Lines 5-8: `author.name` and `author.email`

3. **README.md**
   - Line 13: Reference to tweakcc tool repository
   - Line 17: Reference to tweakcc tool repository
   - Line 27: Marketplace add command

**Total Branding Instances:** 23 locations across 12 files

### Changing Ownership

If transferring ownership again:

```bash
# 1. Update all JSON files with new owner info
find . -name "plugin.json" -o -name "marketplace.json" | \
  xargs sed -i '' 's/support@qrius.global/[new-email]/g'

# 2. Update organization name
find . -name "plugin.json" -o -name "marketplace.json" | \
  xargs sed -i '' 's/QRIUS/[NewOrg]/g'

# 3. Update README.md references
sed -i '' 's/qrius\/claude-code-lsps/[new-org]\/claude-code-lsps/g' README.md

# 4. Bump all versions to signal ownership change
# (Manual edit required - see "Version Bumps" above)

# 5. Verify changes
git diff
```

---

## Integration with Global CLAUDE.md

This project follows the orchestration principles defined in `~/.claude/CLAUDE.md`:

### Role Hierarchy

**Gemini (Chief Architect):**
- Decides on adding/removing languages
- Approves LSP server version upgrades
- Makes architectural decisions about marketplace structure

**Claude (Implementation Engine):**
- Gathers information about LSP servers
- Implements configuration changes faithfully
- Validates JSON syntax and structure
- Updates documentation

### Task Execution Pattern

For non-trivial changes, follow the **ReAct Framework**:

1. **Thought:** Understand requirement and assess simplicity
2. **Action:** Gather context (read configs, check upstream LSP servers)
3. **Observation:** Present findings to Gemini for decision
4. **Implementation:** Execute Gemini's architectural guidance exactly

### Concurrent Operations

When making bulk changes (e.g., version bumps across 10 plugins):

```markdown
✅ CORRECT: Single message with 10 parallel Edit tool calls
❌ WRONG: 10 sequential messages (6x slower)
```

**Example: Version Bump Workflow**
```
[Single Message]:
- Read(marketplace.json)
- Edit(vtsls/plugin.json), Edit(rust-analyzer/plugin.json), ...
- Edit(marketplace.json)
- TodoWrite([update task status])
```

---

## Common Tasks

### Task: Add a New Language Plugin

**Prerequisites:** Gemini approval, upstream LSP server identified

**Steps:**
1. Create plugin directory: `mkdir [lang-name]`
2. Write `plugin.json` with QRIUS branding
3. Write `.lsp.json` with LSP server configuration
4. Add entry to `.claude-plugin/marketplace.json`
5. Add installation section to README.md
6. Test locally with file-based marketplace
7. Commit with message: `Add [language] LSP plugin`

**Files Modified:** 3 (marketplace.json, plugin.json, README.md)
**Files Created:** 2 (plugin.json, .lsp.json)

---

### Task: Update LSP Server Command

**Scenario:** Upstream LSP server changes executable name or args

**Steps:**
1. Read current `.lsp.json` configuration
2. Verify new command/args with upstream documentation
3. Update `.lsp.json` with new configuration
4. Test locally to ensure LSP server starts
5. Commit with message: `Update [language] LSP server configuration`

**Files Modified:** 1 (.lsp.json)

---

### Task: Rebrand Repository

**Scenario:** Changing ownership from one organization to another

**Steps:**
1. Consult Gemini for new organization name, email, version bump strategy
2. Update `.claude-plugin/marketplace.json` (owner + all plugin author blocks)
3. Update all 10 `plugin.json` files (author blocks)
4. Update README.md (marketplace add command, tool references)
5. Bump all versions if Gemini approves
6. Create/update CLAUDE.md with new ownership
7. Commit with message: `Rebrand to [new-org]/claude-code-lsps`

**Files Modified:** 12 (1 marketplace.json, 10 plugin.json, 1 README.md, 1 CLAUDE.md)
**Branding Instances Changed:** 23+

---

## Maintenance Guidelines

### Dependency Management

**This project has ZERO runtime dependencies.** However, it has **documentation dependencies**:

- Must track upstream LSP server installation methods
- Must update README.md when package managers change installation commands
- Must verify upstream LSP servers are still actively maintained

**Quarterly Review Checklist:**
- [ ] Check all 10 upstream LSP server repositories for activity
- [ ] Verify installation commands still work (npm, cargo, apt, brew)
- [ ] Update README.md with any new installation methods
- [ ] Consider adding newly popular LSP servers

### Versioning Strategy

**Plugin Versions:**
- `0.x.0`: Breaking changes (ownership, LSP server major version)
- `0.0.x`: Patch changes (bug fixes, documentation)

**When to Bump:**
- ✅ Ownership change → Bump to next minor version (0.1.0 → 0.2.0)
- ✅ LSP server command/args change → Bump patch (0.2.0 → 0.2.1)
- ✅ Adding new language → No bump for existing plugins
- ❌ README.md updates → No version bump
- ❌ Fixing typos in descriptions → No version bump

### Backward Compatibility

**Iron Law:** Never break existing users' installations.

**Safe Changes:**
- Adding new languages (no impact on existing plugins)
- Updating README.md documentation
- Adding optional LSP server settings
- Improving `.lsp.json` configurations (if backward compatible)

**Breaking Changes (Require Version Bump):**
- Changing LSP server executable names
- Changing required initialization options
- Removing file extension mappings
- Changing ownership/branding

---

## Troubleshooting

### Common Issues

**Issue:** Plugin installed but LSP features don't work

**Diagnosis:**
1. Check if LSP server executable is installed (`which [executable]`)
2. Check if Claude Code has `$ENABLE_LSP_TOOL=1` environment variable set
3. Check Claude Code logs for LSP server startup errors
4. Verify file extension matches `.lsp.json` configuration

**Resolution:**
- Install missing LSP server (see README.md)
- Add LSP server executable to PATH
- Apply tweakcc patches if using raw Claude Code

---

**Issue:** Plugin shows in marketplace but won't install

**Diagnosis:**
1. Check JSON syntax in `plugin.json` and `.lsp.json`
2. Verify `source` path in `marketplace.json` is correct
3. Check file permissions (must be readable)

**Resolution:**
- Validate JSON: `jq . < plugin.json`
- Fix `source` path to `./[language-name]`
- Fix file permissions: `chmod 644 plugin.json .lsp.json`

---

**Issue:** LSP server crashes or restarts repeatedly

**Diagnosis:**
1. Check LSP server supports stdio transport
2. Check initialization options are valid
3. Check LSP server version compatibility

**Resolution:**
- Update LSP server to latest version
- Review upstream LSP server documentation
- Adjust `initializationOptions` in `.lsp.json`
- Consider setting `maxRestarts: 0` for debugging

---

## Contributing

### Contribution Guidelines

**Accepted Contributions:**
- ✅ New language plugins (with mature upstream LSP servers)
- ✅ Bug fixes in LSP server configurations
- ✅ Documentation improvements
- ✅ Installation instruction updates

**Rejected Contributions:**
- ❌ Custom LSP server implementations (use upstream servers only)
- ❌ Adding source code or build processes
- ❌ Complex plugin logic (keep it declarative)
- ❌ Experimental or unmaintained LSP servers

### Pull Request Checklist

Before submitting a PR:

- [ ] All JSON files are valid (`jq` validation passes)
- [ ] Branding is consistent (QRIUS, support@qrius.global)
- [ ] README.md updated if adding new language
- [ ] Installation instructions tested on clean system
- [ ] Plugin tested locally with file-based marketplace
- [ ] Commit message follows format: `[Action] [description]`
- [ ] PR description explains rationale and testing performed

---

## Architecture Decision Records

### ADR-001: Configuration-Only Architecture

**Decision:** Use pure JSON configuration with zero source code.

**Rationale:**
- Minimizes maintenance burden
- Delegates implementation complexity to upstream LSP servers
- Reduces attack surface (no code execution in plugins)
- Simplifies contribution process (edit JSON, not code)

**Trade-offs:**
- Limited to what Claude Code's LSP system supports
- Cannot customize LSP behavior beyond configuration
- Dependent on Claude Code's LSP implementation quality

---

### ADR-002: Thin Wrapper Philosophy

**Decision:** Plugins point to upstream LSP servers, don't implement features.

**Rationale:**
- Leverage existing, battle-tested LSP servers
- Benefit from upstream bug fixes and improvements
- Avoid maintaining language-specific parsing/analysis code
- Reduce barrier to adding new languages

**Trade-offs:**
- Users must install LSP servers separately
- Plugin version ≠ LSP server version (can be confusing)
- No control over upstream LSP server quality

---

### ADR-003: Single Source of Truth (marketplace.json)

**Decision:** `.claude-plugin/marketplace.json` is the central registry.

**Rationale:**
- Claude Code requires this structure for marketplace discovery
- Provides single place to list all plugins
- Enables atomic updates to all plugins
- Simplifies validation (one file to check)

**Trade-offs:**
- Duplication between marketplace.json and individual plugin.json files
- Must keep versions synchronized manually
- Larger git diffs when bumping versions

---

## References

- [Claude Code Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Language Server Protocol Specification](https://microsoft.github.io/language-server-protocol)
- [tweakcc - Claude Code Patching Tool](https://github.com/Piebald-AI/tweakcc)
- [Claude Code LSP Support Announcement](https://www.reddit.com/r/ClaudeAI/comments/1otdfo9/lsp_is_coming_to_claude_code_and_you_can_try_it)

---

**Document Version:** 1.0
**Last Updated:** 2025-11-19
**Maintained By:** QRIUS (support@qrius.global)
