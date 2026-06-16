---
title: Execute the iOS tweet permalink policy
type: testing
date: 2026-06-16
status: completed
execution: code
---

# Execute the iOS tweet permalink policy

## Goal

Compile and execute the deterministic tweet-permalink decision used by the iOS
sample without requiring Fabric, TwitterKit, credentials, a simulator, or live
Twitter content.

## Requirements

- Keep one Foundation-only permalink policy in production source and the iOS
  app target.
- Preserve the existing pre-navigation validator call and legacy public helper
  signatures.
- Compile the production policy with a standalone Swift harness from every Make
  gate when `swiftc` is available.
- Accept the four canonical Twitter/X hosts case-insensitively and reject a
  missing URL, non-HTTPS schemes, userinfo, passwords, ports, unlisted
  subdomains, host prefixes/suffixes, unrelated hosts, and hostless URLs.
- Keep Android, Wear, live-service behavior, and template XCTest targets outside
  the claimed behavioral evidence.

## Implementation Units

### U1: Extract the production policy

Files: `iOS/TableViewTweetsSwift/TableViewTweetsSwift/TweetPermalinkPolicy.swift`,
`iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift`,
`iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj`

Move the existing Foundation-only helper functions into a production file,
retain the legacy Swift compatibility path, and keep navigation delegated to
the shared validator.

### U2: Execute the policy in portable verification

Files: `Tests/TweetPermalinkPolicyTests/main.swift`,
`scripts/run-ios-tweet-permalink-policy-tests.sh`, `Makefile`,
`scripts/check-ios-tweet-permalink.py`, `scripts/check-baseline.sh`

Compile the exact production policy with a standalone input matrix, run it when
`swiftc` exists, and add static contracts for source delegation, target
membership, runner wiring, test coverage, and completed plan evidence.

### U3: Document the verification boundary

Files: `AGENTS.md`, `CHANGES.md`, `README.md`, `SECURITY.md`, `VISION.md`

Record what the harness proves and retain the device, TwitterKit, Android/Wear,
and live-service exclusions.

## Work Completed

- Extracted the production Foundation-only policy and added it to the iOS app
  target while preserving the legacy navigation helper signatures.
- Added a standalone Swift input matrix and bounded temporary-build runner.
- Wired every Make alias to execute the harness when `swiftc` is available.
- Added static contracts for production delegation, Xcode target membership,
  runner inputs, accepted and hostile cases, documentation, and plan evidence.

## Verification Completed

- all four Make gates passed from the repository root.
- The absolute Makefile path passed from an external directory.
- The production policy mutation failed after weakening a host constraint.
- The navigation delegation mutation failed after bypassing the validator.
- The Xcode target membership mutation failed after removing the policy source.
- The accepted URL mutation failed after removing a canonical case.
- The hostile URL mutation failed after removing a rejected case.
- The plan evidence mutation failed after reopening the completion status.
- Shell syntax, project references, executable modes, diff checks, artifact
  scans, and changed-line credential-pattern scans passed.
- `swiftc` and Xcode are unavailable on this Linux host, so local gates verify
  deterministic source wiring and defer Swift execution to the hosted pull-request check.
