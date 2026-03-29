---
name: toon-json-compression
description: Use when processing large JSON payloads (API responses, schemas, configs) that need to be fed to an LLM or included in a prompt to reduce token consumption. Triggers on "curl", "curl json", "compress json", "toon", "reduce json tokens", "compress api response", "pipe json", "large json", "minimize json for prompt", "api response toon". Use when curl/fetch returns JSON that will be passed to Claude or another AI.
---

# TOON JSON Compression

## Overview

TOON is a YAML-like format that strips JSON's structural noise (quotes, braces, brackets) while preserving all data. Typical savings: 10–30% token reduction.

## When to Use

- Piping API responses into prompts: `curl ... | toon`
- Processing OpenAPI/Swagger specs, large configs, or JSON data before passing to LLM
- Any JSON > 500 tokens that will be read by an AI

## Quick Reference

```bash
# Basic: pipe JSON through toon
curl https://api.example.com/data | toon

# From file
toon input.json

# Check savings before committing
curl https://api.example.com/data | toon --stats

# Key folding: collapse deep nested keys (a.b.c.d: value)
toon --keyFolding=safe input.json

# Pipe delimiter for compact arrays
toon --delimiter="|" input.json

# Save to file
toon input.json -o output.toon

# Decode back to JSON
toon --decode output.toon
```

## Key Options

| Flag | Default | Effect |
|------|---------|--------|
| `--stats` | off | Show token savings estimate |
| `--keyFolding=safe` | off | Fold `a: {b: {c: v}}` → `a.b.c: v` |
| `--delimiter=","` | `,` | Array delimiter: `,` `\t` `\|` |
| `--expandPaths=safe` | off | Expand dotted keys to nested objects (decode) |
| `--indent` | `2` | Indentation size |

## Examples

**Input JSON:**
```json
{"name":"John","hobbies":["reading","coding"],"address":{"city":"NYC","zip":"10001"}}
```

**TOON output:**
```yaml
name: John
hobbies[2]: reading,coding
address:
  city: NYC
  zip: "10001"
```

**With key folding (`--keyFolding=safe`):**
```json
{"a":{"b":{"c":{"d":"value"}}},"items":[{"id":1,"name":"foo"},{"id":2,"name":"bar"}]}
```
```yaml
a.b.c.d: value
items[2]{id,name}:
  1,foo
  2,bar
```

## Common Workflow

```bash
# Check how much you'd save on an API spec
curl https://petstore.swagger.io/v2/swagger.json | toon --stats

# Feed compressed output directly into a prompt context
SCHEMA=$(curl https://api.example.com/schema | toon --keyFolding=safe)
```

## Common Mistakes

- **Passing TOON to non-AI consumers** — TOON is for LLM input only; APIs and parsers expect JSON. Decode back with `--decode` when needed.
- **Skipping `--stats`** — always check savings on new data sources; small/flat JSON may not benefit.
- **Using `--keyFolding` on shallow data** — only helps when nesting depth > 2.
