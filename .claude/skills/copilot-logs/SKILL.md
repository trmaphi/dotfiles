---
name: copilot-logs
description: Use when debugging logs for services deployed with AWS Copilot. Triggers on "copilot logs", "copilot svc logs", "cloudwatch logs", "aws logs", "deployment failed", "check logs", "debug production", "what happened", "copilot manifest", "copilot/svc/ws/", "ecs logs", "task logs", "filter-log-events", "start-query logs", when the working directory contains copilot/ directory with service manifests
---

# AWS CloudWatch + AWS Copilot Log Investigation

Focus: AWS Copilot CLI + AWS CLI

## Environment Context

- **Log Group:** `/copilot/<App>-<Env>-<Service>`
- **Log Stream:** `copilot/<Service>/<TaskID>`

## Triage: "What Just Happened?"

```bash
APP="my-app" ENV="prod" SVC="api"

aws logs filter-log-events \
    --log-group-name "/copilot/$APP-$ENV-$SVC" \
    --filter-pattern "?ERROR ?Panic ?Fatal" \
    --interleaved \
    --limit 20 \
    --output table
```

## Deep Dive: CloudWatch Insights

```bash
QUERY="fields @timestamp, @message, @logStream
| filter @message like /Exception/
| sort @timestamp desc
| limit 10"

QUERY_ID=$(aws logs start-query \
    --log-group-name "/copilot/$APP-$ENV-$SVC" \
    --start-time $(date -d '1 hour ago' +%s) \
    --end-time $(date +%s) \
    --query-string "$QUERY" \
    --query 'queryId' --output text)

sleep 5
aws logs get-query-results --query-id $QUERY_ID
```

## JSON Log Flattener

```bash
copilot svc logs -n api -e prod --limit 10 --json | \
  jq -r '.[] | [.timestamp, .log] | @tsv' | \
  column -t -s $'\t'
```

## Pro-Tips

- Use `--interleaved` to see event sequence across multiple containers
- `filter-log-events` costs $0.50/GB scanned — use narrow `--start-time`/`--end-time` windows
