# Wear Destroyed Node Send Race Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

status: completed

**Goal:** Stop Wear node lookup and message delivery when `MainActivity` is destroyed after the worker's reconnect guard.

**Architecture:** Extend the existing volatile activity-owned lifecycle boundary at the two remaining asynchronous handoffs. Use one lifecycle lock to make destruction publication and send initiation mutually exclusive while keeping network waits outside the lock. Keep the legacy raw thread, Google API client, and payload behavior unchanged.

**Tech Stack:** Java 7, Android Activity lifecycle, legacy Google Play Services Wear API, shell/Python source contracts.

---

### Task 1: Add the failing lifecycle contract

**Files:**
- Modify: `scripts/check-baseline.sh:690`

**Step 1: Write the failing test**

Extend the worker-ordering Python contract to require an
`if (activityDestroyed)` guard after `getConnectedNodes(...).await()`, then a
shared lifecycle lock around the per-node destruction check and
`Wearable.MessageApi.sendMessage` initiation. Require `onDestroy` to use the same
lock while publishing destruction and disconnecting.

**Step 2: Run test to verify it fails**

Run: `./scripts/check-baseline.sh`

Expected: FAIL because the current worker has no post-node-lookup or pre-send
destruction guard.

### Task 2: Add minimal worker guards

**Files:**
- Modify: `Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java:184`

**Step 1: Implement the minimal fix**

Return with the existing generic destroyed-activity diagnostic immediately
after node lookup when `activityDestroyed` is true. Add one lifecycle lock and
use it around each per-node check/send initiation and around destruction
publication/client disconnect. Await each send result after releasing the lock.

**Step 2: Run focused test to verify it passes**

Run: `./scripts/check-baseline.sh`

Expected: PASS.

### Task 3: Document and validate the cycle

**Files:**
- Modify: `CHANGES.md:3`
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `docs/manual-sample-verification.md`
- Modify: `docs/plans/2026-06-26-wear-destroyed-node-send-race.md`

**Step 1: Record the lifecycle boundary**

Document that node lookup and each send must stop after activity destruction,
including the local validation limit for the retired platform stack.

**Step 2: Run full validation**

Run: `make check`

Expected: PASS for executable portable policies and baseline contracts.

Run: `git diff --check`

Expected: PASS with no output.

**Step 3: Run hostile mutations**

Temporarily remove each new guard independently and run
`./scripts/check-baseline.sh`.

Expected: FAIL for both mutations; restore the implementation after each run.

**Step 4: Commit**

```bash
git add Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java scripts/check-baseline.sh CHANGES.md AGENTS.md README.md SECURITY.md VISION.md docs/manual-sample-verification.md docs/plans/2026-06-26-wear-destroyed-node-send-race-design.md docs/plans/2026-06-26-wear-destroyed-node-send-race.md
git commit -m "fix: stop Wear sends after activity destruction"
```

## Verification Completed

- `./scripts/check-baseline.sh` failed first on the missing post-node-lookup and
  pre-send destruction guards.
- `make check` passed after the minimal Java change; Swift and Xcode execution
  skipped because those tools are unavailable locally.
- Removing the post-node guard or the atomic per-send lifecycle boundary made
  the baseline fail with the expected lifecycle-ordering diagnostic.
- `sh -n` for the repository shell scripts and `git diff --check` passed.
