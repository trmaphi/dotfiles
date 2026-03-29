---
name: bw-vault
description: Use when the user asks to create, read, update, or list Bitwarden vault items, secure notes, passwords, or folders. Triggers on "bitwarden", "bw ", "vault", "create secure note", "store password", "get secret from vault".
---

# Bitwarden Vault CLI (bw)

Manage Bitwarden vault items, secure notes, and passwords from the terminal.

## Prerequisites

- User must be logged in (`bw login` already done in their terminal)
- User must provide `BW_SESSION` or run `bw unlock` and share the session key

## Critical: Session Handling

**Piped commands lose the session context.** Always use one of these patterns:

### Pattern 1: Script file (recommended for create/update)

Write a `.sh` script and run it with `bash`. This preserves session across the entire pipeline:

```bash
#!/bin/bash
set -e

export BW_SESSION="<session_key>"

bw get template item | \
  jq '.type=2 | .name="My Item" | .folderId="<folder_id>" | .notes="<content>"' | \
  bw encode | \
  bw create item
```

### Pattern 2: Single-line env + heredoc + base64

```bash
export BW_SESSION="<session_key>" && \
  PAYLOAD=$(cat <<'JSONEOF' | base64 -w 0
{"type":2,"name":"My Note","folderId":"<id>","notes":"secret content","secureNote":{"type":0}}
JSONEOF
) && bw create item "$PAYLOAD"
```

### Pattern 3: Read operations (session env var works fine)

For `list`, `get`, `status` — a single command with `export BW_SESSION` works:

```bash
export BW_SESSION="<session_key>" && \
  bw list items --search "proxy"
```

## Quick Reference

| Action | Command |
|--------|---------|
| Status | `bw status` |
| List folders | `bw list folders` |
| List items | `bw list items` |
| Search items | `bw list items --search "query"` |
| Get template | `bw get template item` |
| Create item | `bw create item <encoded_json>` |
| Get item | `bw get item <id>` |
| Get password | `bw get password <id>` |
| Sync vault | `bw sync` |

## Item Types

| Type | Value | Use |
|------|-------|-----|
| Login | `1` | Username/password combos |
| Secure Note | `2` | Free-text secrets, API keys, tokens |
| Card | `3` | Credit/debit cards |
| Identity | `4` | Personal info |
| SSH Key | `5` | SSH keys |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Piping `bw` commands loses session | Write a script file and `bash` it |
| Using `--session` flag with pipes | Use `export BW_SESSION` inside script |
| Missing `secureNote` field for type 2 | Always include `"secureNote":{"type":0}` |
| Forgetting `base64 -w 0` | macOS base64 wraps at 76 chars by default; `-w 0` prevents this |
| Shell interpreting special chars in session key | Always quote the session key |
