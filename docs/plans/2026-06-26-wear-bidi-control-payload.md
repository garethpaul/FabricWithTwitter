# Wear Bidi-Control Payload Implementation Plan

**Status:** Completed

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Prevent Unicode bidirectional controls from visually reordering untrusted Wear tweet notification text.

**Architecture:** Extend the existing strict payload policy with one exact `Bidi_Control` predicate after UTF-8 decoding. Keep the portable Java policy harness authoritative and add a source mutation proving the new guard matters.

**Tech Stack:** Java 7, legacy Android Wear, Unicode 17 property data, POSIX shell, Python 3 mutation checks, GNU Make

---

### Task 1: Add failing behavioral coverage

**Files:**
- Modify: `Tests/WearMessagePolicyTests.java`

**Step 1: Add bidi-control rejection cases**

Require rejection for `U+061C`, `U+200E`, `U+202E`, and `U+2066` embedded in
otherwise visible text.

**Step 2: Preserve ZWJ text**

Require `U+200D` to remain accepted so the policy does not expand to every
Unicode format character.

**Step 3: Run the focused test red**

Run: `scripts/run-wear-message-policy-tests.sh`

Expected: FAIL because bidi controls are currently accepted.

### Task 2: Implement the exact policy

**Files:**
- Modify: `Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java`

**Step 1: Add the exact code-point predicate**

Match only the four Unicode `Bidi_Control` ranges.

**Step 2: Reject before returning normalized text**

Keep existing strict UTF-8, whitespace, and ISO-control checks unchanged.

**Step 3: Run the focused test green**

Run: `scripts/run-wear-message-policy-tests.sh`

Expected: PASS.

### Task 3: Pin mutations and guidance

**Files:**
- Create: `scripts/test-wear-bidi-control-mutation.sh`
- Modify: `Makefile`
- Modify: `scripts/check-baseline.sh`
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `CHANGES.md`

**Step 1: Add an isolated mutation**

Remove the bidi-control condition and require the focused harness to fail.

**Step 2: Synchronize maintained guidance**

Document exact bidi-control rejection and ZWJ preservation.

### Task 4: Verify and deliver

**Files:**
- Modify: `docs/plans/2026-06-26-wear-bidi-control-payload.md`

**Step 1: Run local gates**

Run focused policy and mutation tests, `make check`, external-Makefile
`make check`, shell syntax, and `git diff --check`.

**Step 2: Open and review the PR**

Push the exact head, open a PR against `master`, and run
`codex review --base origin/master`.

**Step 3: Merge only the green exact head**

Require hosted checks and CodeQL, verify head and approval policy, then merge
with `--match-head-commit`.

## Verification Results

- The focused Java harness failed red-first because `U+061C` was accepted.
- The harness passes after exact rejection of all four Unicode `Bidi_Control`
  groups, while `U+200D` remains accepted.
- Wear bidi-control mutation was rejected by the behavioral assertions.
- Repository and external-Makefile `make check`, shell syntax, whitespace, and
  `make security` passed; gitleaks reported no findings.
- `swiftc` and `xcodebuild` were unavailable on the Linux runner, so hosted
  macOS project parsing remains required.
- Live Wear notification rendering was not exercised locally.
