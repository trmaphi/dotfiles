---
name: toon
description: Use when compressing JSON for LLM prompts or reducing token usage. Triggers on "toon", "compress json", "reduce tokens", "minimize json", "pipe json", "large json", "api response too big", "shrink json", "json to yaml", "token savings", "compress api response", "curl json too large", "fit json in context", "trim json payload", "json token budget", "less tokens json"
---

# TOON - JSON Compression for LLMs

Strips JSON structural noise (quotes, braces, brackets). Typical savings: 10-30% fewer tokens.

```bash
curl -s https://api.example.com/data | toon          # pipe JSON through toon
toon input.json                                       # from file
toon --stats input.json                               # show token savings
toon --keyFolding=safe input.json                     # flatten deep nesting: a.b.c.d: v
toon --decode output.toon                             # back to JSON
```

| Flag | Effect |
|------|--------|
| `--stats` | Show before/after token estimate |
| `--keyFolding=safe` | Fold `a: {b: {c: v}}` → `a.b.c: v` |
| `--delimiter="\|"` | Array delimiter (default `,`) |
| `--decode` | TOON back to JSON |

**Input JSON** → **TOON output:**
```json
{"name":"John","hobbies":["reading","coding"],"address":{"city":"NYC","zip":"10001"}}
```
```yaml
name: John
hobbies[2]: reading,coding
address:
  city: NYC
  zip: "10001"
```

Use for any JSON > 500 tokens going into a prompt. Decode with `--decode` for non-AI consumers.