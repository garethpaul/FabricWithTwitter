# Wear Node Dispatch Destruction Design

status: completed

## Problem

The Wear mobile worker checks `activityDestroyed` before and after connection,
but connected-node discovery and each message send are also blocking handoffs.
If `onDestroy` runs during node discovery or between nodes, the worker can still
dispatch a tweet from an activity that no longer owns the client.

## Options Considered

1. Move delivery to a service. This changes the historical sample architecture.
2. Interrupt the raw worker thread. The legacy awaited APIs do not expose a
   reliable cancellation contract here.
3. Recheck after node discovery, then atomically pair the owner check with each
   message submission under a lifecycle lock.

## Decision

Use option 3. Preserve the client, worker, payload, and Wear API structure. Treat
node discovery and each per-node send as asynchronous ownership boundaries. Do
not hold the lifecycle lock while awaiting remote completion.

## Verification

- Add a source-order contract that fails while the post-discovery and per-node
  guards are absent.
- Reject hostile removal of either guard.
- Run the portable baseline and hosted macOS verification.

## Verification Completed

- `make check` failed before implementation because node discovery and per-node
  dispatch had no destruction ordering contract.
- Local and absolute-Makefile checks passed after implementation.
- Removing the post-discovery guard and replacing the shared lifecycle lock were
  both rejected by the baseline.
- Swift execution and Xcode project listing remain hosted-only on this Linux
  workstation.
