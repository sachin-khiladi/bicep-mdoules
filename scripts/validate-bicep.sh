#!/usr/bin/env bash
set -euo pipefail

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI is required. Install Azure CLI first."
  exit 1
fi

if ! az bicep version >/dev/null 2>&1; then
  echo "Bicep CLI is required. Install with: az bicep install"
  exit 1
fi

if ! find . -type f -name '*.bicep' | grep -q .; then
  echo "No .bicep files found."
  exit 0
fi

echo "Running format check..."
find . -type f -name '*.bicep' | sort | while IFS= read -r file; do
  tmp_file="$(mktemp)"
  az bicep format --file "$file" --outfile "$tmp_file"
  if ! cmp -s "$file" "$tmp_file"; then
    rm -f "$tmp_file"
    echo "Formatting check failed: $file"
    exit 1
  fi
  rm -f "$tmp_file"
done

echo "Running lint + build checks..."
find . -type f -name '*.bicep' | sort | while IFS= read -r file; do
  az bicep lint --file "$file"
  az bicep build --file "$file" >/dev/null
done

echo "All checks passed."
