# Wear Node Dispatch Destruction Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

status: completed

**Goal:** Stop Wear message dispatch when `MainActivity` is destroyed during node discovery or between node sends.

**Architecture:** Extend the existing volatile activity-owner signal across the remaining blocking worker handoffs without changing the legacy `GoogleApiClient` or raw-thread structure.

**Tech Stack:** Java 7, legacy Google Play Services Wear API, shell/Python repository contracts.

---

## Tasks

1. Add a failing source-order contract for post-discovery and per-node guards.
2. Recheck destruction after connected-node discovery.
3. Atomically pair each destruction check with message submission.
4. Synchronize lifecycle guidance and manual verification.
5. Run hostile mutations, full checks, hosted review, and exact-head merge.

## Verification Completed

- Red-first `make check` rejected the missing post-discovery and per-node
  ownership handoffs.
- Local and absolute-Makefile checks passed with the lifecycle lock in place.
- Two isolated hostile mutations were rejected: post-discovery guard removal
  and replacement of the shared per-node lifecycle lock.
- `git diff --check` and shell syntax checks passed.
- Hosted macOS and exact-head review remain the final closeout gates.
