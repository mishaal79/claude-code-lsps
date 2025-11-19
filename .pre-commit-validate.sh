#!/bin/bash
# Manual validation script (alternative to pre-commit)
# Run this before committing changes to validate all JSON files

set -e

echo "🔍 Validating JSON files in mish-cc-market..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ Error: jq is not installed${NC}"
    echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)"
    exit 1
fi

echo "✓ jq is installed"
echo ""

# 1. Validate all JSON files syntax
echo "📝 Validating JSON syntax..."
while IFS= read -r -d '' file; do
    if jq empty "$file" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file - Invalid JSON syntax"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find . -name "*.json" -not -path "./.git/*" -not -path "./node_modules/*" -print0)

echo ""

# 2. Validate marketplace.json structure
echo "📦 Validating marketplace.json structure..."
if jq -e '.name and .owner and .metadata and .plugins' .claude-plugin/marketplace.json > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} marketplace.json has required fields"
else
    echo -e "  ${RED}✗${NC} marketplace.json missing required fields (name, owner, metadata, plugins)"
    ERRORS=$((ERRORS + 1))
fi

# Check plugin count
PLUGIN_COUNT=$(jq '.plugins | length' .claude-plugin/marketplace.json)
echo -e "  ${GREEN}✓${NC} Found $PLUGIN_COUNT plugins in marketplace"

echo ""

# 3. Validate plugin.json files
echo "🔌 Validating plugin.json files..."
while IFS= read -r -d '' file; do
    if jq -e '.name and .version and .description and .author and .repository and .license and .keywords' "$file" > /dev/null 2>&1; then
        PLUGIN_NAME=$(jq -r '.name' "$file")
        echo -e "  ${GREEN}✓${NC} $file ($PLUGIN_NAME)"
    else
        echo -e "  ${RED}✗${NC} $file - Missing required fields"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find . -name "plugin.json" -not -path "./.git/*" -print0)

echo ""

# 4. Validate .lsp.json files
echo "🛠️  Validating .lsp.json files..."
while IFS= read -r -d '' file; do
    # Get the language ID key (first key in the object)
    LANG_ID=$(jq -r 'keys[0]' "$file")

    if jq -e ".\"$LANG_ID\".command and .\"$LANG_ID\".languages and .\"$LANG_ID\".fileExtensions and .\"$LANG_ID\".transport and .\"$LANG_ID\".maxRestarts" "$file" > /dev/null 2>&1; then
        COMMAND=$(jq -r ".\"$LANG_ID\".command" "$file")
        LANG_COUNT=$(jq -r ".\"$LANG_ID\".languages | length" "$file")
        EXT_COUNT=$(jq -r ".\"$LANG_ID\".fileExtensions | length" "$file")
        echo -e "  ${GREEN}✓${NC} $file ($LANG_ID: $COMMAND, $LANG_COUNT langs, $EXT_COUNT exts)"

        # Check minimum array lengths
        if [ "$LANG_COUNT" -lt 1 ]; then
            echo -e "  ${RED}✗${NC} $file - languages array must have at least 1 item"
            ERRORS=$((ERRORS + 1))
        fi
        if [ "$EXT_COUNT" -lt 1 ]; then
            echo -e "  ${RED}✗${NC} $file - fileExtensions array must have at least 1 item"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo -e "  ${RED}✗${NC} $file - Missing required fields (command, languages, fileExtensions, transport, maxRestarts)"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find . -name ".lsp.json" -not -path "./.git/*" -print0)

echo ""

# 5. Check marketplace plugins match actual directories
echo "🔗 Validating marketplace plugin references..."
jq -r '.plugins[].source' .claude-plugin/marketplace.json | while read -r source; do
    dir="${source#./}"
    if [ -d "$dir" ]; then
        echo -e "  ${GREEN}✓${NC} $dir exists"
    else
        echo -e "  ${RED}✗${NC} $dir - Directory not found"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# 6. Check plugin directories have both required files
echo "📂 Validating plugin directory structure..."
for dir in */; do
    if [ -f "${dir}plugin.json" ]; then
        if [ -f "${dir}.lsp.json" ]; then
            echo -e "  ${GREEN}✓${NC} ${dir%/} has both plugin.json and .lsp.json"
        else
            echo -e "  ${RED}✗${NC} ${dir%/} missing .lsp.json"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Summary
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo ""
    echo "Safe to commit changes."
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s)${NC}"
    echo ""
    echo "Fix the errors above before committing."
    exit 1
fi
