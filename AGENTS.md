# AGENTS.md

## Repository purpose

`garethpaul/FabricWithTwitter` is a collection of legacy Android, Wear, iOS,
and watchOS samples that demonstrate the retired Fabric and TwitterKit SDKs.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Android` - repository source or sample assets
- `iOS` - repository source or sample assets

## Development commands

- Install dependencies: use the historical Android Studio/Gradle and Xcode
  environments documented by each sample; no current one-command install is
  available.
- Full baseline: `make check`
- External baseline: `make -f /absolute/path/to/Makefile check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Preserve the existing Java and Swift style; avoid broad SDK modernization in
  changes intended only to maintain the historical samples.

## Testing guidance

- Tests exist under both Android sample trees and the two iOS Xcode projects.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- Detected references to Twitter. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.
- Keep `FABRIC_API_KEY`, `FABRIC_BUILD_SECRET`, Twitter keys/tokens, Android keystores, signing identities, `.env`, and `.xcconfig` files out of source control.
- Do not log raw tweet objects, Twitter exception messages, or account-specific display data from sample apps.
- Do not log raw Wear message paths or payloads; keep cross-device diagnostics generic.
- Wear tweet loading skips missing, empty, or whitespace-only tweet text before sending messages to the watch or displaying watch notifications.
- Wear notification display verifies that the text view target exists before setting tweet text.
- Wear notification PendingIntents must refresh the latest validated tweet extra.
- WearableListenerService owns background message delivery; do not add a
  parallel GoogleApiClient listener registration or cleanup lifecycle.

- The iOS TableView sample type-checks TwitterKit response objects before
  replacing visible rows.
- The iOS TableView sample must validate a credential-free HTTPS permalink with
  a non-empty host before constructing a web request.
- CI must remain read-only, credential-free, pinned to immutable actions, and
  capable of parsing both Xcode projects on macOS.
- Preserve the Android legacy dependency pins; do not restore dynamic `+`,
  `latest`, or range selectors in Gradle declarations.
- Use `docs/manual-sample-verification.md` for runtime claims. Preserve its
  per-sample results, fixed public-content warning, Wear UTF-8/1024-byte and
  component boundaries, validated iOS permalink boundary, no-force-crash rule,
  cleanup, redaction, and unexecuted Linux status.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
