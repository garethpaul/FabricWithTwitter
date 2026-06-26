---
title: Modern Platform Alternatives
type: implementation-plan
date: 2026-06-25
status: completed
execution: documentation
---

# Modern Platform Alternatives Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Document current, security-conscious alternatives for every Fabric, TwitterKit, and legacy Wear capability represented by the samples without rewriting the historical applications.

**Architecture:** Add one capability-oriented guide backed by official provider documentation, then link it from the repository's operational documents. Enforce the guide's scope, sources, migration stages, and non-implementation warning with the existing POSIX baseline gate.

**Tech Stack:** Markdown, POSIX shell static contracts, repository Make gates.

---

### Task 1: Establish the failing documentation contract

**Files:**
- Modify: `scripts/check-baseline.sh`
- Add: `docs/plans/2026-06-25-modern-platform-alternatives-design.md`
- Add: `docs/plans/2026-06-25-modern-platform-alternatives.md`

1. Require the design, plan, and modern alternatives guide as baseline files.
2. Require official Firebase, X, and Android source links, explicit guidance-only
   language, staged validation, and synchronized repository-document links.
3. Run `make check`; expect failure because the guide and synchronized links do
   not exist yet.

### Task 2: Publish the capability migration map

**Files:**
- Add: `docs/modern-platform-alternatives.md`

1. Map crash reporting, native authentication, content lookup, browser fallback,
   and phone/watch transport to current platform capabilities.
2. State credential ownership, security constraints, non-goals, and validation
   gates for each stage.
3. Use primary provider documentation and require implementers to recheck
   access, versions, pricing, and terms before writing migration code.

### Task 3: Synchronize repository guidance

**Files:**
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `AGENTS.md`
- Modify: `CHANGES.md`

1. Link the guide from setup, security, roadmap, and maintainer guidance.
2. Remove the completed roadmap priority while preserving the separate legacy
   Android replacement and executable-test priorities.
3. Record the documentation change and its no-runtime-migration boundary.

### Task 4: Verify and ship the maintenance cycle

**Files:**
- Modify: `docs/plans/2026-06-25-modern-platform-alternatives.md`

1. Run the narrow shell syntax gate and full Make aliases.
2. Run diff, generated-artifact, and credential-pattern audits.
3. Push a focused PR, run exact-head review and hosted checks, and merge only
   after all required checks pass.

## Verification Completed

- `make check` failed first with `Required file missing:
  docs/modern-platform-alternatives.md`, proving the new contract was active.
- The guide maps every represented capability to current primary provider
  documentation without changing historical runtime source or dependencies.
- README, security, vision, agent, and change-log guidance link the guide, and
  the completed roadmap item was removed from `VISION.md`.
- `make check` passed locally after the guide and synchronized references were
  added; Swift and Xcode execution remain hosted requirements on this machine.
- `make lint`, `make test`, `make build`, and absolute-Makefile `make check`
  passed with the same baseline results.
- Shell syntax, Python compilation, diff whitespace, generated-artifact, and
  high-confidence credential-pattern audits passed; the temporary Python cache
  created by compilation was removed.
