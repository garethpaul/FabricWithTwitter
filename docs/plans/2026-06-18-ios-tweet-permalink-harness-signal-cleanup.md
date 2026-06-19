---
title: iOS Tweet Permalink Harness Signal Cleanup
type: reliability
date: 2026-06-18
status: completed
execution: code
---

# iOS Tweet Permalink Harness Signal Cleanup

## Status: Completed

## Summary

Make the standalone iOS tweet-permalink policy runner remove its temporary
build directory when interrupted while `swiftc` is still running.

## Baseline

The runner removes its build directory after success and compiler failure, but
its exit-only signal traps leave `ios-tweet-permalink-policy-tests.*` behind
after `TERM` under the repository's POSIX `/bin/sh` execution path.

## Requirements

- Invoke cleanup directly from each signal handler before returning the
  conventional signal-derived status.
- Keep normal exit cleanup and existing compiler/test behavior unchanged.
- Add a mutation-sensitive static contract that rejects exit-only handlers.
- Verify success, compiler failure, and bounded termination with isolated fake
  compilers and temporary directories.

## Verification Completed

- `sh -n` passed for the runner and baseline gate.
- `make check`, `make lint`, `make test`, and `make build` passed from the
  repository, and absolute-Makefile `make check` passed from `/tmp`.
- Isolated fake compilers proved success cleanup, compiler-failure cleanup with
  status 42, and bounded `TERM` cleanup with no residual temporary directory.
- Mutations removing the direct cleanup call and restoring the exit-only
  `TERM` binding were rejected by the baseline gate.
- Diff, executable-mode, worktree, generated-artifact, and high-confidence
  credential-pattern audits passed.
- The implementation was committed and pushed as
  `937c91a17e010ab47b811c4a194d7f299843a769`.
- Pull-request run `27746955355` completed successfully on that exact head,
  including the hosted Swift harness and Xcode project checks. PR #13 remained
  open, clean, and mergeable, with zero open branch code-scanning or Dependabot
  alerts.
- Linux still cannot execute Swift, Xcode, Android devices, TwitterKit,
  wearable transport, or iOS navigation; those platform boundaries remain
  outside this deterministic runner fix.
