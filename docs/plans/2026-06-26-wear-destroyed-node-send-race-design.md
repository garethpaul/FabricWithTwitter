# Wear Destroyed Node Send Race Design

status: approved

## Problem

The Wear mobile worker checks `activityDestroyed` after `blockingConnect`, but
the activity can still be destroyed while `getConnectedNodes(...).await()` is
running or between node iterations. In either ordering, the worker can continue
using the activity-owned `GoogleApiClient` and send a message after
`onDestroy` has disconnected it.

## Options Considered

1. Move message delivery into a service with its own lifecycle. This changes the
   legacy sample architecture and is disproportionate to the race.
2. Add cancellation plumbing around the raw worker thread. The historical Wear
   APIs used here do not expose a useful cancellation boundary for the blocking
   node and send calls.
3. Recheck after node lookup, then serialize destruction publication with each
   send initiation using one activity lifecycle lock. This preserves the sample
   and closes both remaining asynchronous handoffs without holding the lock
   during the network wait.

## Decision

Use option 3. Return after node lookup when destruction occurred while waiting.
For each node, hold the lifecycle lock while checking the destruction signal and
starting `sendMessage`, then release it before awaiting the result. `onDestroy`
uses the same lock while publishing destruction and disconnecting the client.
This guarantees no send is initiated after destruction is published without
blocking activity teardown on an in-flight network wait. Do not reconnect,
introduce a service, or change payload validation.

## Verification

Strengthen the baseline source contract first so the current implementation
fails. The contract must require a guard between node lookup and iteration and
an atomic lifecycle-check/send boundary inside the loop, paired with atomic
destruction publication. Then add the minimal Java synchronization, run
`make check`, and prove hostile removal of either boundary fails.
Device behavior remains a hosted/manual boundary because the retired Wear stack
is not locally executable.
