# iOS Tweet Permalink ASCII Path Design

Status: Approved

## Problem

The production permalink policy validates handles with `CharacterSet.alphanumerics` and status IDs with `CharacterSet.decimalDigits`. Both sets include Unicode characters, so canonical hosts can still accept lookalike handles or non-ASCII decimal digits even though the portable reference regex permits only `[A-Za-z0-9_]` and `[0-9]`.

## Options

1. Validate each path component's UTF-8 bytes against the exact ASCII ranges. This directly expresses the canonical grammar, adds no dependency, and works in both the legacy Swift source and the current executable harness.
2. Require ASCII encodability before retaining the existing character-set checks. This is smaller but splits one grammar across two validation mechanisms and remains easier to weaken accidentally.
3. Introduce a regular expression in production. This matches the Python reference model but adds Foundation regex setup and avoidable legacy Swift complexity.

## Decision

Use option 1. Add dedicated ASCII handle and status-ID helpers, then keep the existing host, scheme, credential, port, component-count, and trailing-slash rules unchanged.

## Verification

- Add executable rejections for a Cyrillic handle lookalike and Arabic-Indic status digits.
- Make the portable checker require the ASCII byte-range helpers and the new hostile cases.
- Run the standalone policy harness in hosted macOS CI and keep both Xcode projects parseable.
