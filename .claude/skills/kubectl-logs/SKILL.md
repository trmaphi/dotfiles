---
name: kubectl-logs
description: Use when debugging Kubernetes pods, troubleshooting container issues, investigating crashes, or need to view application logs from kubectl
---

# kubectl-logs

## Overview

Read container logs from Kubernetes pods using `kubectl logs`. Supports streaming, filtering, multi-container pods, and historical logs from crashed containers.

## When to Use

- Debugging application errors in pods
- Investigating container crashes or restarts
- Monitoring application output in real-time
- Troubleshooting failing deployments
- Viewing logs from previous container instances

## Quick Reference

| Task | Command |
|------|---------|
| Basic logs | `kubectl logs <pod-name>` |
| Stream logs | `kubectl logs -f <pod-name>` |
| Last N lines | `kubectl logs --tail=100 <pod-name>` |
| Since time | `kubectl logs --since=1h <pod-name>` |
| Previous container | `kubectl logs --previous <pod-name>` |
| Specific container | `kubectl logs <pod-name> -c <container-name>` |
| All pods by label | `kubectl logs -l app=myapp` |
| With timestamps | `kubectl logs --timestamps <pod-name>` |
| Limit bytes | `kubectl logs --limit-bytes=10000 <pod-name>` |

## Common Patterns

### Debug CrashLoopBackOff
```bash
# View logs from crashed container
kubectl logs --previous <pod-name>

# If multi-container pod
kubectl logs --previous <pod-name> -c <container-name>
```

### Stream with Context
```bash
# Follow logs with timestamps for last hour
kubectl logs -f --timestamps --since=1h <pod-name>
```

### Multi-Container Pods
```bash
# List containers in pod first
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].name}'

# Get logs from specific container
kubectl logs <pod-name> -c <container-name>

# Get logs from all containers
for c in $(kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].name}'); do
  echo "=== $c ==="
  kubectl logs <pod-name> -c $c --tail=50
done
```

### Logs from Deployments
```bash
# Get logs from all pods matching a label
kubectl logs -l app=myapp --all-containers=true

# Specific pod from deployment
kubectl logs deployment/myapp
```

### Time-Based Filtering
```bash
# Last 30 minutes
kubectl logs --since=30m <pod-name>

# Since specific time
kubectl logs --since-time=2024-01-15T10:00:00Z <pod-name>

# Combine with tail
kubectl logs --since=1h --tail=200 <pod-name>
```

### Search and Filter
```bash
# Grep for errors
kubectl logs <pod-name> | grep -i error

# Grep with context
kubectl logs <pod-name> | grep -A 5 -B 5 "exception"

# Exclude noise
kubectl logs <pod-name> | grep -v "health check"
```

### Logs from Multiple Pods
```bash
# Using stern for multi-pod logs (if installed)
stern <pod-prefix>

# Native kubectl with label selector
kubectl logs -l app=myapp --prefix=true --all-containers=true
```

## Common Mistakes

### Forgetting `-n` for non-default namespaces
```bash
# ❌ Wrong - won't find pod in other namespace
kubectl logs mypod

# ✅ Correct
kubectl logs mypod -n mynamespace
```

### Not using `--previous` for crashed pods
```bash
# ❌ Wrong - shows nothing if pod restarted
kubectl logs mypod

# ✅ Correct - shows logs before crash
kubectl logs --previous mypod
```

### Ignoring multi-container pods
```bash
# ❌ Wrong - may get wrong container or error
kubectl logs mypod

# ✅ Correct - specify container
kubectl logs mypod -c app-container
```

### Streaming without limits
```bash
# ❌ Can overwhelm terminal with high-volume logs
kubectl logs -f mypod

# ✅ Better - start with recent logs
kubectl logs -f --tail=100 mypod
```

## Advanced Usage

### JSON Logs with jq
```bash
# Parse JSON logs
kubectl logs <pod-name> | jq '.'

# Filter by log level
kubectl logs <pod-name> | jq 'select(.level == "error")'

# Extract specific fields
kubectl logs <pod-name> | jq -r '.message'
```

### Export Logs
```bash
# Save to file with timestamp
kubectl logs <pod-name> > logs-$(date +%Y%m%d-%H%M%S).txt

# All pods to separate files
for pod in $(kubectl get pods -l app=myapp -o name); do
  kubectl logs $pod > "${pod#pod/}.log"
done
```

### Compare Current vs Previous
```bash
# Side-by-side comparison
diff <(kubectl logs --previous <pod-name>) <(kubectl logs <pod-name>)
```

## Related Commands

- `kubectl describe pod` - Events and status
- `kubectl get events` - Cluster-level events
- `kubectl exec` - Run commands in container
- `kubectl top` - Resource usage

## Red Flags

| Symptom | Check |
|---------|-------|
| Empty logs | Pod just started? Use `--previous` if restarted |
| Logs cut off | Use `--limit-bytes` or pipe to file |
| Wrong output | Multi-container pod? Specify `-c` |
| No timestamps | Add `--timestamps` flag |
| Too much noise | Use `--since` or `grep` to filter |
