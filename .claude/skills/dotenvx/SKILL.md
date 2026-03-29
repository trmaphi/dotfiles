---
name: dotenvx
description: Use when working with .env files, environment variable management, secrets encryption, or running commands that need environment variables loaded. Triggers on "dotenvx", "env encryption", "encrypt .env", "decrypt env", "keypair", ".env.keys", "DOTENV_PRIVATE_KEY", or when setting/getting environment secrets.
---

# dotenvx

A secure dotenv from the creator of dotenv. Encrypts `.env` files using AES-256 + Secp256k1 (same crypto as Bitcoin). Encrypted `.env` files are safe to commit; private keys stay separate.

## Core Concept

Plaintext `.env` → attack vector. Encrypted `.env` + separate private key → cryptographic separation.

- `.env` file: encrypted values, **safe to commit**
- `.env.keys`: private decryption keys, **never commit**
- Public key embedded in `.env` file header for encryption

## CLI Quick Reference

### Running commands with env vars

```bash
# Basic: load .env and run command
dotenvx run -- node index.js

# Specific env file
dotenvx run -f .env.production -- node index.js

# Multiple env files (later files win)
dotenvx run -f .env.local -f .env -- node index.js

# Framework conventions
dotenvx run --convention=nextjs -- node index.js
dotenvx run --convention=flow -- node index.js

# Override with env var directly
dotenvx run --env HELLO=World -- node index.js

# Verbose/debug output
dotenvx run --verbose -- node index.js
dotenvx run --debug -- node index.js
dotenvx run --quiet -- node index.js
```

### Encryption

```bash
# Set a value (auto-encrypts)
dotenvx set DB_PASSWORD "secret123"
dotenvx set DB_PASSWORD "secret123" -f .env.production

# Set plain (no encryption)
dotenvx set DEBUG --plain

# Encrypt entire file
dotenvx encrypt
dotenvx encrypt -f .env.production

# Decrypt entire file (for migration)
dotenvx decrypt -f .env.production
dotenvx decrypt --stdout -f .env.production

# Generate keypair
dotenvx keypair
dotenvx keypair -f .env.production

# Rotate keys (re-encrypt with new keypair)
dotenvx rotate
dotenvx rotate -f .env.production
```

### Reading values

```bash
# Get single value (auto-decrypts)
dotenvx get DB_PASSWORD

# Get from specific file
dotenvx get DB_PASSWORD -f .env.production

# Get all values as JSON
dotenvx get

# All values formatted
dotenvx get --format shell
dotenvx get --format eval
```

### Listing

```bash
# List .env files in current directory
dotenvx ls

# List all .env files recursively
dotenvx ls -ef
```

### Extensions

```bash
# Generate .env.example from .env (strips values)
dotenvx ext genexample

# Add to .gitignore
dotenvx ext gitignore

# Scan for leaked secrets
dotenvx ext scan
```

### Library (Node.js)

```js
// Drop-in replacement for dotenv
require('@dotenvx/dotenvx').config()

// Custom path
require('@dotenvx/dotenvx').config({ path: ['.env.local', '.env'] })

// Overwrite existing env vars
require('@dotenvx/dotenvx').config({ overload: true })

// Strict mode: error on missing required vars
require('@dotenvx/dotenvx').config({ strict: true })
```

## Decryption Key Sources

`dotenvx run` checks these in order:
1. `DOTENV_PRIVATE_KEY_<ENV>` env var (e.g. `DOTENV_PRIVATE_KEY_PRODUCTION`)
2. `DOTENV_PRIVATE_KEY` env var (fallback)
3. `.env.keys` file (local development)

## Environment Variable Precedence

1. System env vars (highest)
2. `--env KEY=VALUE` flags
3. `.env` files (last `-f` wins)
4. `.env.keys` for decryption

## Common Patterns

### Production deployment
```bash
# Server has DOTENV_PRIVATE_KEY_PRODUCTION set
# .env.production is committed (encrypted, safe)
dotenvx run -f .env.production -- node index.js
```

### Local development
```bash
# .env.keys exists locally (gitignored)
dotenvx run -- node index.js
```

### Docker
```bash
# Multi-stage: build with encrypted .env, run with key as env var
FROM node:20
COPY . .
RUN npm ci
CMD ["dotenvx", "run", "--", "node", "index.js"]
# Pass DOTENV_PRIVATE_KEY as container env
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Committing `.env.keys` | Add to `.gitignore` via `dotenvx ext gitignore` |
| Committing plaintext `.env` | Encrypt it: `dotenvx encrypt` |
| Forgetting `-f` for specific env | Use `-f .env.production` explicitly |
| Key not found at runtime | Set `DOTENV_PRIVATE_KEY` env var on server |
| Using old `dotenv` import | Switch to `require('@dotenvx/dotenvx').config()` |

## Install

```bash
npm install @dotenvx/dotenvx --save
# or use npx without installing
npx dotenvx --help
```
