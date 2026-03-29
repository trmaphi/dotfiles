---
name: qsv
description: Use when wrangling, inspecting, transforming, or analyzing CSV/tabular data from the command line. Triggers on "qsv", "csv stats", "csv frequency", "dedup csv", "join csv", "csv search", "sample csv", "partition csv", "sniff csv", "csv to sql", or any tabular data pipeline task
---

# qsv - CSV Data Wrangling Swiss Army Knife

## Overview

`qsv` is a Rust-based command-line tool for CSV data. 61 commands for inspecting, transforming, joining, and analyzing tabular data. Zero-dependency, multithreaded, blindingly fast.

```bash
qsv <command> [options] <input>            # Most commands read stdin or a file
qsv <command1> | qsv <command2>            # Pipeable - Unix philosophy
qsv --list                                 # All 61 commands
```

## Quick Reference: Most-Used Commands

### Inspect

```bash
qsv sniff data.csv              # Detect delimiter, dialect, types, mime
qsv stats data.csv              # Summary stats per column (mean, stddev, min/max, etc.)
qsv frequency -s col data.csv   # Frequency table for a column (value, count, %)
qsv count data.csv              # Row count
qsv headers data.csv            # Column names only
qsv schema data.csv             # JSON Schema from CSV
qsv table data.csv              # Pretty-print aligned table
qsv validate data.csv           # RFC4180 compliance check
```

### Select & Filter

```bash
qsv select 1,3,5 data.csv          # Columns by index
qsv select name,age data.csv       # Columns by name
qsv select '!3-' data.csv          # Drop column 3 onward
qsv search 'error' data.csv        # Regex filter rows
qsv search -i 'error' -s msg file  # Case-insensitive on column "msg"
qsv slice -i 10 -n 20 data.csv     # Rows 10-29
qsv sample 100 data.csv            # Random 100 rows (reservoir sampling)
qsv sample 0.1 data.csv            # 10% Bernoulli sample (constant memory)
```

### Transform

```bash
qsv sort -N data.csv               # Numeric sort
qsv sort -s price -R data.csv      # Descending by column
qsv dedup data.csv                 # Remove duplicate rows
qsv dedup --select col1 data.csv   # Dedup on specific columns
qsv rename 'old,new' data.csv      # Rename column
qsv fill -s col data.csv           # Fill nulls with previous value
qsv datefmt -s date '%Y-%m-%d'     # Reformat dates
qsv apply 'col|upper()' data.csv   # Apply transformation
qsv safenames data.csv             # Make headers DB-safe
```

### Combine

```bash
qsv join id left.csv id right.csv           # Inner join on column
qsv join --left id left.csv id right.csv    # Left join
qsv join --outer id left.csv id right.csv   # Full outer join
qsv cat row file1.csv file2.csv             # Stack rows
qsv cat col file1.csv file2.csv             # Stack columns
```

### Convert & Output

```bash
qsv to sqlite data.csv              # Load into SQLite
qsv to postgres 'connstr' file.csv  # Load into PostgreSQL
qsv json data.csv                   # CSV to JSON
qsv jsonl data.csv                  # CSV to NDJSON
qsv tojsonl data.csv                # CSV to NDJSON (aliased)
qsv fmt -d '\t' data.csv            # Change delimiter (e.g. to TSV)
```

### Split & Partition

```bash
qsv split -n 10 data.csv                    # Split into 10 files by rows
qsv partition category . data.csv           # Split into files by column value
qsv partition --filename "{}-{}.csv" col .  # Custom output naming
```

## Performance Tips

- `qsv index data.csv` creates an index enabling multithreaded operations (stats, search, sample)
- Set `QSV_AUTOINDEX_SIZE` to auto-index files above a size threshold
- For files larger than memory: `extsort` instead of `sort`, `extdedup` instead of `dedup`
- Pipe commands: `qsv select 1,2 data.csv | qsv sort -N | qsv dedup -o clean.csv`

## Common Mistakes

- **Forgetting `-o`** - output goes to stdout by default; use `-o file.csv` to write to file
- **Quotes in select** - column names with spaces: use the column index instead
- **Join column mismatch** - both sides must have same number of key columns
- **Not indexing large files** - `stats` and `search` are single-threaded without an index