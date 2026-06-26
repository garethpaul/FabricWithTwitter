# Wear Destroyed Activity Callback Design

status: approved

## Problem

The Wear mobile sample starts asynchronous TwitterKit work from an `Activity`.
If the activity is destroyed before a tweet callback completes, the callback can
still call `sendMessage`. Its worker then sees the disconnected
`GoogleApiClient`, calls `blockingConnect`, and reconnects a client whose owner
has already been destroyed. The same callback can also try to add a tweet view
to the dead activity.

## Options Considered

1. Cancel TwitterKit requests during `onDestroy`. The retired API does not expose
   a stable cancellation handle in this sample.
2. Move Wear delivery into a long-lived service. This changes sample ownership
   and is broader than the lifecycle defect.
3. Add an activity-owned destruction signal and check it at callback, dispatch,
   and post-connect boundaries. This preserves the historical architecture and
   closes both callback orderings around `onDestroy`.

## Decision

Use a `volatile` destruction signal owned by `MainActivity`. Set it before
disconnecting the client. Reject delayed tweet callbacks and new message work
after destruction. Recheck immediately before callback-owned UI publication so
destruction racing an already-running callback cannot update dead views. The
background worker checks both before and after
`blockingConnect`; if destruction happens while connecting, it disconnects the
client before returning.

## Verification

The repository baseline will enforce the signal and ordering contracts. A
hostile mutation that removes the callback guard or reconnect cleanup must make
`make check` fail. Full device behavior remains in the manual verification
matrix because the retired TwitterKit and Wear stack is unavailable locally.
