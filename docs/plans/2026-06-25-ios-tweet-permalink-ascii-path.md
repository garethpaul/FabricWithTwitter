# iOS Tweet Permalink ASCII Path Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Restrict canonical tweet permalink handles and status IDs to their documented ASCII grammar.

**Architecture:** Add two small pure Swift UTF-8 byte validators and call them at the existing path-policy boundary. Keep the portable Python reference regex and navigation wiring unchanged.

**Tech Stack:** Legacy-compatible Swift, Foundation, standalone `swiftc` policy harness, Python and shell baseline checks.

---

### Task 1: Establish the failing path contract

**Files:**
- Modify: `Tests/TweetPermalinkPolicyTests/main.swift`
- Modify: `scripts/check-ios-tweet-permalink.py`

1. Add rejected canonical-host URLs containing a Cyrillic handle lookalike and Arabic-Indic status digits.
2. Require production ASCII handle and status helper contracts.
3. Run `make check`; expect failure because the production helpers do not exist.

### Task 2: Implement exact ASCII validation

**Files:**
- Modify: `iOS/TableViewTweetsSwift/TableViewTweetsSwift/TweetPermalinkPolicy.swift`

1. Add UTF-8 byte validators for `[A-Za-z0-9_]+` handles and `[0-9]+` status IDs.
2. Replace Unicode-wide character-set acceptance with the new helpers.
3. Run `make check`; expect all portable checks to pass and hosted Swift execution to remain required locally.

### Task 3: Record and validate the maintenance cycle

**Files:**
- Modify: `CHANGES.md`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`

1. Document the ASCII-only canonical path boundary.
2. Run Python compilation, shell syntax, `git diff --check`, and all Make aliases.
3. Push a PR, run exact-head review and hosted checks, then squash merge only when green.

## Verification Completed

- `make check` failed first because the required production ASCII helpers were absent.
- All four Make aliases pass with exact byte-range source contracts and hostile Unicode URL cases.
- Python compilation and `git diff --check` pass locally; standalone Swift execution remains a hosted requirement because `swiftc` is unavailable locally.
- Hosted Check run `28212033264` compiled and executed the production Swift policy, passed the complete baseline and secret scan, and all CodeQL languages passed on commit `7336934638ea66c9ae433bb922458d70af4003f3`.
- The Codex review helper could not authenticate; exact-head manual review found no actionable findings.
