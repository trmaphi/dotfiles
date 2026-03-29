---
name: gcloud-logging
description: Use when debugging GKE production clusters, searching Cloud Logging for Kubernetes logs, investigating production issues, or need to query historical container logs
---

# gcloud-logging

## Overview

Search and analyze Google Cloud Logging (Cloud Logging) for GKE clusters. Provides powerful filtering, historical queries, and production debugging capabilities beyond `kubectl logs`.

## When to Use

- Debugging production issues in GKE
- Searching historical logs (beyond current pod lifecycle)
- Querying logs across multiple pods/nodes
- Investigating incidents after they occurred
- Log analysis and pattern detection
- When `kubectl logs` is insufficient

## Quick Reference

| Task | Command |
|------|---------|
| Basic search | `gcloud logging read "resource.type=gke_container"` |
| Filter by cluster | `gcloud logging read "resource.labels.cluster_name=prod"` |
| Filter by namespace | `gcloud logging read "resource.labels.namespace_name=default"` |
| Filter by pod | `gcloud logging read "resource.labels.pod_name=my-pod"` |
| Time range | `gcloud logging read "timestamp>\"2024-01-15T10:00:00Z\""` |
| Search text | `gcloud logging read "textPayload:\"error\""` |
| JSON payload | `gcloud logging read "jsonPayload.message:\"error\""` |
| Limit results | `gcloud logging read "..." --limit=100` |
| Freshness | `gcloud logging read "..." --freshness=1h` |

## GKE Resource Filters

### Basic GKE Container Logs
```bash
# All logs from a specific GKE cluster
gcloud logging read "resource.type=gke_container AND resource.labels.cluster_name=prod-cluster"

# Specific namespace
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod-cluster
  AND resource.labels.namespace_name=production"

# Specific pod
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod-cluster
  AND resource.labels.pod_name=my-app-12345-abcde"

# Specific container
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod-cluster
  AND resource.labels.container_name=app"
```

### System Logs (kube-system, node logs)
```bash
# Kube-system namespace
gcloud logging read "resource.type=gke_container
  AND resource.labels.namespace_name=kube-system"

# Node problem detector
gcloud logging read "resource.type=gke_cluster
  AND logName:node-problem-detector"

# GKE system logs
gcloud logging read "resource.type=gke_cluster"
```

## Time-Based Filtering

### Relative Time
```bash
# Last hour
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod"
  --freshness=1h

# Last 24 hours
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod"
  --freshness=24h

# Last 7 days
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod"
  --freshness=7d
```

### Absolute Time
```bash
# After specific time
gcloud logging read 'resource.type=gke_container
  AND timestamp>"2024-01-15T10:00:00Z"'

# Time range
gcloud logging read 'resource.type=gke_container
  AND timestamp>="2024-01-15T10:00:00Z"
  AND timestamp<"2024-01-15T12:00:00Z"'

# Using RFC 3339 format
gcloud logging read 'resource.type=gke_container
  AND timestamp>="2024-01-15T10:00:00-08:00"'
```

## Common Production Queries

### Error Investigation
```bash
# Search for errors in production
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND (textPayload:"error" OR textPayload:"exception" OR textPayload:"failed")'
  --limit=100

# HTTP 5xx errors
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND textPayload:"500"'

# JSON payload with error field
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND jsonPayload.level="ERROR"'
```

### Crash Investigation
```bash
# OOMKilled events
gcloud logging read 'resource.type=gke_container
  AND textPayload:"OOMKilled"'

# Container restarts
gcloud logging read 'resource.type=gke_container
  AND (textPayload:"Killing" OR textPayload:"Stopping container")'

# Crash loop events
gcloud logging read 'resource.type=gke_container
  AND resource.labels.namespace_name=kube-system
  AND textPayload:"BackOff"'
```

### Performance Issues
```bash
# Slow requests (>1s)
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND jsonPayload.duration>1000'

# High latency warnings
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND textPayload:"latency"'

# Connection timeouts
gcloud logging read 'resource.type=gke_container
  AND (textPayload:"timeout" OR textPayload:"ETIMEDOUT")'
```

### Network Issues
```bash
# Connection refused
gcloud logging read 'resource.type=gke_container
  AND textPayload:"Connection refused"'

# DNS issues
gcloud logging read 'resource.type=gke_container
  AND (textPayload:"DNS" OR textPayload:"NXDOMAIN" OR textPayload:"no such host")'

# Istio/Service mesh errors
gcloud logging read 'resource.type=gke_container
  AND labels."k8s-pod/app"="istio-ingressgateway"
  AND textPayload:"error"'
```

### Audit & Security
```bash
# Authentication failures
gcloud logging read 'resource.type=gke_container
  AND (textPayload:"authentication failed" OR textPayload:"unauthorized")'

# RBAC denials
gcloud logging read 'resource.type=k8s_cluster
  AND protoPayload.status.message:"forbidden"'

# Admin activity
gcloud logging read 'resource.type=k8s_cluster
  AND protoPayload.authenticationInfo.principalEmail:"admin"'
```

## Advanced Patterns

### Search Across All Pods by Label
```bash
# All pods with specific label
gcloud logging read 'resource.type=gke_container
  AND labels."k8s-pod/app"="my-service"
  AND resource.labels.cluster_name=prod'
```

### Multi-Condition Queries
```bash
# Errors in specific service during time window
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND labels."k8s-pod/app"="payment-service"
  AND (textPayload:"error" OR jsonPayload.level="ERROR")
  AND timestamp>="2024-01-15T10:00:00Z"
  AND timestamp<"2024-01-15T11:00:00Z"'
```

### JSON Output & Processing
```bash
# Format as JSON
gcloud logging read "resource.type=gke_container" --format=json

# Extract specific fields with jq
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND textPayload:"error"'
  --format=json | jq -r '.[] | "\(.timestamp) \(.textPayload)"'

# Pretty print with table format
gcloud logging read "resource.type=gke_container"
  --format="table(timestamp, resource.labels.pod_name, textPayload)"
```

### Export and Analysis
```bash
# Export to file
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND timestamp>="2024-01-15T00:00:00Z"'
  --format=json > logs-2024-01-15.json

# Count errors by pod
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND textPayload:"error"'
  --format=json | jq -r '.[].resource.labels.pod_name' | sort | uniq -c | sort -rn

# Extract unique error messages
gcloud logging read 'resource.type=gke_container
  AND textPayload:"error"'
  --format=json | jq -r '.[].textPayload' | sort | uniq -c | sort -rn | head -20
```

### Live Tail (Streaming)
```bash
# Stream new logs (poll every 5 seconds)
watch -n 5 'gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod"
  --freshness=30s --limit=20'
```

## Common Mistakes

### Wrong Resource Type
```bash
# ❌ Wrong - gke_cluster for container logs
gcloud logging read "resource.type=gke_cluster"

# ✅ Correct - gke_container for application logs
gcloud logging read "resource.type=gke_container"
```

### Missing Quotes in Queries
```bash
# ❌ Wrong - unquoted timestamp
gcloud logging read "timestamp>2024-01-15T10:00:00Z"

# ✅ Correct - properly quoted
gcloud logging read 'timestamp>"2024-01-15T10:00:00Z"'
```

### Case Sensitivity Issues
```bash
# ❌ Wrong - exact case match only
gcloud logging read 'textPayload:"Error"'

# ✅ Correct - case-insensitive search
gcloud logging read 'textPayload:"Error" OR textPayload:"error" OR textPayload:"ERROR"'
```

### Forgetting Project ID
```bash
# ❌ Wrong - uses default project
gcloud logging read "resource.type=gke_container"

# ✅ Correct - explicit project
gcloud logging read "resource.type=gke_container" --project=my-prod-project
```

### Too Broad Queries
```bash
# ❌ Wrong - scans everything
gcloud logging read "textPayload:error"

# ✅ Correct - scoped to cluster and time
gcloud logging read "resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND textPayload:error"
  --freshness=1h
```

## Performance Tips

### Limit Results
```bash
# Always use --limit for broad queries
gcloud logging read "resource.type=gke_container" --limit=100

# Use --page-size for large queries
gcloud logging read "resource.type=gke_container" --page-size=1000
```

### Scope by Time
```bash
# Always narrow time range
gcloud logging read 'resource.type=gke_container
  AND timestamp>="2024-01-15T10:00:00Z"
  AND timestamp<"2024-01-15T11:00:00Z"'
```

### Use Specific Filters
```bash
# Combine multiple filters to reduce scan
gcloud logging read 'resource.type=gke_container
  AND resource.labels.cluster_name=prod
  AND resource.labels.namespace_name=production
  AND resource.labels.container_name=app'
```

## Red Flags

| Symptom | Check |
|---------|-------|
| No results | Verify resource type, cluster name, time range |
| Too many results | Add more filters, use --limit |
| Query too slow | Narrow time range, add resource filters |
| Missing recent logs | Use --freshness, check log ingestion delay |
| Wrong format | Use --format=json or --format=table |

## Related Commands

- `kubectl logs` - Direct container log access
- `gcloud logging sinks list` - Export destinations
- `gcloud logging metrics list` - Log-based metrics
- `gcloud container clusters describe` - Cluster info
