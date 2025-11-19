# JSON Validation for mish-cc-market

Local pre-commit validation for JSON files in the marketplace.

## Requirements

- **jq** - JSON processor
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt-get install jq

  # Arch Linux
  sudo pacman -S jq
  ```

## Usage

### Option 1: Manual Validation (Recommended)

Run validation script before committing:

```bash
./pre-commit-validate.sh
```

**What it validates:**
- ✅ JSON syntax for all `.json` files
- ✅ `marketplace.json` structure (name, owner, metadata, plugins)
- ✅ `plugin.json` required fields (name, version, description, author, repository, license, keywords)
- ✅ `.lsp.json` required fields (command, args, extensionToLanguage, transport, maxRestarts)
- ✅ Marketplace plugin references match actual directories
- ✅ Plugin directories have both `plugin.json` and `.lsp.json`

**Output:**
```
🔍 Validating JSON files in mish-cc-market...

✓ jq is installed

📝 Validating JSON syntax...
  ✓ ./python/plugin.json
  ✓ ./python/.lsp.json
  ...

📦 Validating marketplace.json structure...
  ✓ marketplace.json has required fields
  ✓ Found 25 plugins in marketplace

🔌 Validating plugin.json files...
  ✓ ./python/plugin.json (python)
  ...

🛠️  Validating .lsp.json files...
  ✓ ./python/.lsp.json (python: ty)
  ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All validations passed!

Safe to commit changes.
```

### Option 2: Pre-commit Hook (Optional)

Install pre-commit framework:

```bash
# Using pip
pip install pre-commit

# Or using pipx (recommended)
pipx install pre-commit
```

Install hooks:

```bash
pre-commit install
```

Now validations run automatically on `git commit`.

**Manual run:**
```bash
pre-commit run --all-files
```

## What Gets Validated

### 1. JSON Syntax
All `.json` files are parsed with `jq` to ensure valid syntax.

### 2. Marketplace Structure
`.claude-plugin/marketplace.json` must have:
- `name` - Marketplace identifier
- `owner` - Maintainer info
- `metadata` - Description and version
- `plugins` - Array of plugin entries

### 3. Plugin Metadata
Each `plugin.json` must have:
- `name` - Plugin identifier (kebab-case)
- `version` - Semantic version (e.g., "0.1.0")
- `description` - Clear description
- `author` - Name and email
- `repository` - GitHub URL
- `license` - License type (e.g., "MIT")
- `keywords` - Array of tags

### 4. LSP Configuration
Each `.lsp.json` must have:
- `command` - Executable name
- `args` - Command-line arguments array
- `extensionToLanguage` - File extension mappings
- `transport` - Communication method (always "stdio")
- `maxRestarts` - Max restart attempts (always 3)

### 5. Directory Consistency
- All plugin `source` paths in `marketplace.json` must exist
- All plugin directories must have both `plugin.json` and `.lsp.json`

## Fixing Errors

### Invalid JSON Syntax
```bash
# Check specific file
jq . path/to/file.json

# Auto-format (overwrites file)
jq . path/to/file.json > temp.json && mv temp.json path/to/file.json
```

### Missing Required Fields
Add missing fields to match the structure in `.claude/PLUGIN_DEVELOPMENT.md`.

### Missing Plugin Directory
Create the directory referenced in `marketplace.json` with both required files.

### Missing Plugin Files
Ensure each plugin directory has:
- `plugin.json` - Metadata
- `.lsp.json` - LSP configuration

## Workflow

```bash
# 1. Make changes to plugins or marketplace
vim python/plugin.json

# 2. Validate before committing
./pre-commit-validate.sh

# 3. If validation passes, commit
git add -A
git commit -m "Update Python LSP plugin"

# 4. Push to remote
git push
```

## Disabling Validation

If you need to skip validation (not recommended):

```bash
# Skip manual validation
# (just don't run the script)

# Skip pre-commit hooks (if installed)
git commit --no-verify
```

## CI/CD Integration

**Not used.** This marketplace uses local validation only.

For team environments, consider:
- Shared git hooks in `.git/hooks/` (not committed)
- Team documentation requiring validation before push
- Code review process to catch validation issues

## Troubleshooting

### jq not found
Install jq using package manager (see Requirements above).

### Permission denied
Make script executable:
```bash
chmod +x .pre-commit-validate.sh
```

### Validation fails but JSON looks correct
Check for:
- Trailing commas (invalid in JSON)
- Single quotes instead of double quotes
- Comments (not allowed in JSON)
- Unicode characters

Use `jq` to identify exact error:
```bash
jq . file.json
# Will show specific parse error
```

## Files

- `.pre-commit-validate.sh` - Manual validation script (recommended)
- `.pre-commit-config.yaml` - Pre-commit framework config (optional)
- `README-VALIDATION.md` - This documentation

## References

- [jq Manual](https://jqlang.github.io/jq/manual/)
- [pre-commit](https://pre-commit.com/)
- [JSON Specification](https://www.json.org/)
