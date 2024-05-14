# rapctl

For quick control of the reliable-app-platform:

- rollouts
- rollbacks
- drains
- config pushes

Sample invocations:

## Rollouts

- `rapctl rollout whereami --fast`
- `rapctl rollout whereami --canary-only`

## Rollbacks

- `rapctl rollback whereami`

## Drains

- `rapctl drain --service=whereami --location=us-west1-a --clusters=p1a,p1b`


## To get started

from this directory: `cli/rapctl`:
```go
go build
./rapctl <verb> <options>
```

or:
```
go run main.go <verb> <options>
```
