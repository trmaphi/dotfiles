---
name: aws-cloudwatch-aws-copilot
description: Use when investigating CloudWatch logs for AWS Copilot deployed services, querying production logs, debugging deployment failures, or working with AWS CLI log commands in GitHub Actions
---

# AWS CloudWatch + AWS Copilot Investigation Agent

Focus: AWS Copilot CLI + AWS CLI + GitHub Workflow Integration

## Environment Context

When investigating logs for an application deployed via AWS Copilot, the naming convention is strictly:

- **Log Group:** `/copilot/<App>-<Env>-<Service>`
- **Log Stream:** `copilot/<Service>/<TaskID>`

## Core Investigation Recipes

### A. The "What Just Happened?" (Triage)

See the last 20 errors across all tasks in a specific Copilot environment.

```bash
# Set variables for reuse
APP="my-app"
ENV="prod"
SVC="api"

aws logs filter-log-events \
    --log-group-name "/copilot/$APP-$ENV-$SVC" \
    --filter-pattern "?ERROR ?Panic ?Fatal" \
    --interleaved \
    --limit 20 \
    --output table
```

### B. The "Deep Dive" (CloudWatch Insights)

Standard filtering can be slow. Insights is high-performance. This triggers a query and waits for the result.

```bash
# Define the query
QUERY="fields @timestamp, @message, @logStream
| filter @message like /Exception/
| sort @timestamp desc
| limit 10"

# Execute Query
QUERY_ID=$(aws logs start-query \
    --log-group-name "/copilot/$APP-$ENV-$SVC" \
    --start-time $(date -d '1 hour ago' +%s) \
    --end-time $(date +%s) \
    --query-string "$QUERY" \
    --query 'queryId' --output text)

# Retrieve Results (Wait 5 seconds for execution)
sleep 5
aws logs get-query-results --query-id $QUERY_ID
```

## GitHub Actions "Auto-Investigator"

Add this step to your GitHub Workflow (`.github/workflows/deploy.yml`). It triggers only if the deployment fails, automatically posting the logs to your GitHub Action Summary.

```yaml
- name: Auto-Investigate Failure
  if: failure()
  env:
    LOG_GROUP: "/copilot/${{ env.APP }}-${{ env.ENV }}-${{ env.SVC }}"
  run: |
    echo "## Deployment Failure Log Analysis" >> $GITHUB_STEP_SUMMARY
    echo "Checking Log Group: $LOG_GROUP" >> $GITHUB_STEP_SUMMARY

    # Fetch the last 5 minutes of logs with 'error' keywords
    aws logs filter-log-events \
      --log-group-name "$LOG_GROUP" \
      --filter-pattern "?error ?fail ?500" \
      --since 5m \
      --query 'events[*].[timestamp, message]' \
      --output table >> $GITHUB_STEP_SUMMARY
```

## Advanced Utility: The "JSON Flattener"

Copilot services usually output JSON logs. Use this pipe-command to turn messy JSON into a readable table in your terminal.

```bash
copilot svc logs -n api -e prod --limit 10 --json | \
  jq -r '.[] | [.timestamp, .log] | @tsv' | \
  column -t -s $'\t'
```

## Pro-Tips

- **Token Expiration:** If using GitHub Actions, ensure your `aws-actions/configure-aws-credentials` has the `logs:FilterLogEvents` and `logs:StartQuery` permissions.
- **Context Window:** Always look at the 10 lines before an error. Use `--interleaved` to see the sequence of events across multiple containers correctly.
- **Cost Management:** `filter-log-events` scans data and costs money ($0.50 per GB scanned). Use narrow `--start-time` and `--end-time` windows to keep costs low.
