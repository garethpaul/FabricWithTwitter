# DisplayTweets Destroyed Callback Design

status: approved

## Problem

The Android DisplayTweets sample starts an asynchronous TwitterKit load from
`MainActivity`. If the activity is destroyed before the success callback runs,
the callback can still construct `CompactTweetView` instances with the dead
activity and add them to its detached layout.

## Constraints

- The retired TwitterKit API exposes no stable cancellation handle here.
- Preserve the fixed public tweet IDs and current rendering behavior while the
  activity remains alive.
- Avoid broader Android lifecycle or dependency modernization.

## Decision

Add an activity-owned `volatile` destruction signal. Publish it before
`super.onDestroy()`, reject the callback before iterating, and recheck before
each activity-backed view construction/addition.

## Verification

- Add the source contract first and observe the baseline fail.
- Reject hostile removal of the callback and per-item guards.
- Run every Make gate and hosted Android/static verification available to the
  repository.
