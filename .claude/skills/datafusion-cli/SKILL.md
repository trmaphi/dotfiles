---
name: datafusion-cli
description: Use when exploring or querying columnar data files - Parquet, Arrow, Feather, IPC, AVRO. Triggers on "query parquet", "explore feather", "read arrow file", "datafusion", "CREATE EXTERNAL TABLE", "columnar data", or any SQL-over-files task
---

# DataFusion CLI - Columnar Data Exploration

## Overview

DataFusion CLI is a Rust-based SQL engine built on Apache Arrow. Query columnar files directly with SQL - no database setup required.

```bash
datafusion-cli -c "SQL_QUERY"
datafusion-cli                    # Interactive REPL
```

## Quick Reference: CREATE EXTERNAL TABLE

| Format | Syntax | Best For |
|--------|--------|----------|
| **Parquet** | `STORED AS PARQUET LOCATION 'file.parquet'` | Long-term storage, smallest size |
| **Arrow/Feather/IPC** | `STORED AS ARROW LOCATION 'file.feather'` | Fastest load, active trading data |
| **AVRO** | `STORED AS AVRO LOCATION 'file.avro'` | Kafka/Hadoop pipeline data |

## Pattern

```sql
-- 1. Create table pointing to file
CREATE EXTERNAL TABLE bera STORED AS ARROW LOCATION '/path/to/data.feather';

-- 2. Query with standard SQL
SELECT * FROM bera LIMIT 5;
SELECT date, close FROM bera WHERE volume > 0 ORDER BY date DESC LIMIT 10;
SELECT date, AVG(close) AS avg_close FROM bera GROUP BY date ORDER BY date;
```

## Querying Multiple Files

```sql
-- All parquet files in a directory (partitioned datasets)
CREATE EXTERNAL TABLE trades STORED AS PARQUET LOCATION '/path/to/parquets/';

-- Wildcard with glob
SELECT * FROM read_parquet('/path/to/data/*.parquet') LIMIT 10;
```

## Common Operations

```sql
-- Schema inspection
DESCRIBE bera;

-- Aggregations
SELECT MIN(date), MAX(date), COUNT(*) FROM bera;
SELECT date, AVG(close), MAX(high), MIN(low) FROM bera GROUP BY date;

-- Time ranges
SELECT * FROM bera WHERE date >= '2026-01-01' AND date < '2026-02-01';

-- Window functions
SELECT date, close, AVG(close) OVER (ORDER BY date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS sma_20
FROM bera ORDER BY date;
```

## Speed Guide

| Format | Speed | Notes |
|--------|-------|-------|
| Parquet | Fastest query | Predicate pushdown, column pruning, compression |
| Feather/Arrow | Fastest load | Zero-copy memory mapping, ideal for IPC |
| AVRO | Fast | Row-based but efficient in pipelines |

## Common Mistakes

- **Wrong STORED AS type** - must match actual file format exactly
- **Single vs double quotes** - use single quotes for paths in SQL
- **Not quoting paths with spaces** - wrap in single quotes

## Tips

- Use `-c` flag for one-shot queries in scripts and pipes
- Interactive REPL supports arrow keys, history, and multi-line SQL
- Predicate pushdown on Parquet means `WHERE` clauses skip reading irrelevant row groups
- Combine with shell pipes: `datafusion-cli -c "SELECT ..." | head -20`
