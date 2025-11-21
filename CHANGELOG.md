# Changelog

All notable changes to the mish-cc-market LSP marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-11-21

### Added
- CHANGELOG.md for tracking version history
- Version badge in README.md
- Comprehensive documentation in `.claude/LSP.md` for official LSP schema

### Changed
- **BREAKING**: Migrated all 25 LSP configurations to official Claude Code schema
  - Changed from `extensionToLanguage: {}` object to `languages: []` and `fileExtensions: []` arrays
  - All Python LSPs now use `uvx` for per-project .venv isolation
  - Updated validation script to enforce new schema requirements
- **Frontend consolidation**: vtsls now supports 7 languages and 11 file extensions
  - Added support for React, Next.js, SolidJS, TanStack, Vue, Svelte, Astro in single config
- Updated `.pre-commit-validate.sh` to validate official schema
- Updated all documentation (CLAUDE.md, PLUGIN_DEVELOPMENT.md, README.md)

### Fixed
- Marketplace installation command format in documentation (now `mishaal79/mish-claude-code-lsps`)
- Email addresses updated to `mishal@qrius.global` across all plugins
- JSON validation now checks minimum array lengths for `languages` and `fileExtensions`

## [2.0.0] - 2025-11-20

### Added
- Initial marketplace release with 25 LSP server plugins
- Performance-optimized LSP servers prioritizing Rust/Go implementations
- Plugin development toolkit in `.claude/plugin-dev/`
- Pre-commit validation script for JSON schema validation
- Comprehensive installation documentation

### Plugins Included
**Python (5 options)**:
- ty (default, Rust-based, 26x faster)
- pyright (alternative)
- basedpyright (Pylance features)
- pyrefly (Meta/Rust, 1.85M LOC/sec)
- python-pyright (standard)

**Frontend (6 plugins)**:
- vtsls (TypeScript/JavaScript/React/SolidJS)
- superhtml (HTML, Zig-based)
- emmet-language-server (HTML/CSS expansion)
- astro-language-server (Astro)
- svelte-language-server (Svelte)
- tailwindcss-language-server (TailwindCSS)

**Backend Languages (7 plugins)**:
- rust-analyzer (Rust)
- gopls (Go)
- jdtls (Java)
- clangd (C/C++)
- phpactor (PHP)
- ruby-lsp (Ruby)
- omnisharp (C#)

**Tools & Config (7 plugins)**:
- bash-language-server (Shell scripts)
- terraform-ls (Terraform/HCL)
- markdown-oxide (Markdown PKM)
- yaml-language-server (YAML)
- taplo (TOML)
- biome (JS/TS/JSON/CSS unified)
- oxc-language-server (JS/TS Rust-based)

## [Unreleased]

### Planned
- JSON Schema validation for LSP configs
- TypeScript type definitions for marketplace structure
- Automated testing for plugin installations
- GitHub Actions for validation on PR

---

## Version History

- **2.1.0** (2025-11-21) - Official LSP schema migration, UV-based Python, frontend consolidation
- **2.0.0** (2025-11-20) - Initial marketplace release with 25 plugins

[2.1.0]: https://github.com/mishaal79/mish-claude-code-lsps/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/mishaal79/mish-claude-code-lsps/releases/tag/v2.0.0
