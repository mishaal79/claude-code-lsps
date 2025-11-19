# LSP Integration in Claude Code

## Overview

Claude Code 2.0.30+ includes LSP (Language Server Protocol) support for code intelligence features.

## LSP Tool (5 Operations)

Enable with: `export ENABLE_LSP_TOOL=1`

**Available operations:**
- `goToDefinition` - Jump to symbol definition
- `findReferences` - Find all symbol references
- `hover` - Show type/documentation on hover
- `documentSymbol` - List all symbols in file
- `workspaceSymbol` - Search symbols across workspace

## Automatic Diagnostics

LSP servers provide real-time diagnostics (errors, warnings) automatically when files are opened.

## Setup Requirements

1. **Patch Claude Code:** `npx tweakcc --apply`
2. **Install LSP executables:** See README.md for language-specific instructions
3. **Install plugins:** `/plugin install <name>@mish-cc-market`

## LSPServerConfig Schema

Official schema from Claude Code 2.0.30:

```typescript
interface LSPServerConfig {
  command: string;                // Executable command
  args?: string[];                // Command arguments
  languages: string[];            // Language IDs (REQUIRED, min 1)
  fileExtensions: string[];       // File extensions (REQUIRED, min 1)
  transport?: "stdio" | "socket"; // Communication method (default: "stdio")
  env?: Record<string, string>;   // Environment variables
  initializationOptions?: any;    // LSP init options
  settings: any;                  // LSP settings
  workspaceFolder?: string;       // Workspace root path
  maxRestarts?: number;           // Max restart attempts (default: 3)
}
```

## Example Configuration

```json
{
  "typescript": {
    "command": "vtsls",
    "args": ["--stdio"],
    "languages": ["typescript", "javascript", "typescriptreact", "javascriptreact"],
    "fileExtensions": [".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs"],
    "transport": "stdio",
    "settings": {},
    "maxRestarts": 3
  }
}
```

## References

- [Official LSP Spec](https://microsoft.github.io/language-server-protocol/)
- [Plugin Development Guide](.claude/PLUGIN_DEVELOPMENT.md)
- [tweakcc](https://github.com/Piebald-AI/tweakcc)
