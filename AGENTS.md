# AGENTS.md

## Repository purpose

`garethpaul/FabricWithTwitter` is an Apple platform application or Objective-C/Swift sample. A simple application that showcases how to integrate Fabric with Twitter

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Android` - repository source or sample assets
- `iOS` - repository source or sample assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: C/C++ headers (43), Swift (9), Java (6).

## Testing guidance

- Test-related files detected: `iOS/TableViewTweetsSwift/TableViewTweetsSwiftTests/TableViewTweetsSwiftTests.swift`, `iOS/WatchSample/WatchSampleTests/WatchSampleTests.swift`
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

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
