# Wear Bidi-Control Payload Design

## Evidence

- `WearMessagePolicy` rejects malformed UTF-8 and ISO control characters, but
  currently accepts Unicode bidirectional control characters in notification
  and activity text.
- Unicode Security Considerations documents bidirectional text spoofing as a
  visual security issue: <https://www.unicode.org/reports/tr36/tr36-15.html>.
- Unicode 17 `PropList.txt` defines `Bidi_Control` as `U+061C`,
  `U+200E–U+200F`, `U+202A–U+202E`, and `U+2066–U+2069`:
  <https://www.unicode.org/Public/17.0.0/ucd/PropList.txt>.
- Rejecting all Unicode `FORMAT` characters would also reject legitimate emoji
  sequences using zero-width joiner `U+200D`.

## Approaches

### 1. Reject the `Bidi_Control` property set

Fail closed when a decoded tweet contains one of the exact Unicode bidi-control
code points. Preserve all other accepted text, including ZWJ sequences.

### 2. Strip bidi controls

Remove controls and display the remainder. This silently changes untrusted
content and makes sender/receiver text differ.

### 3. Reject all format characters

Use `Character.FORMAT` as the boundary. This is broader but breaks legitimate
ZWJ emoji and other format-dependent text.

## Decision

Reject only the Unicode `Bidi_Control` property set after strict UTF-8 decode
and trimming, before notification construction. Keep newlines, tabs, ZWJ, byte
limits, PendingIntent behavior, and sender encoding unchanged.

## Validation

- Add red behavioral cases for representative bidi-control groups.
- Add a preservation case for `U+200D`.
- Add a hostile mutation that removes the bidi-control rejection.
- Run the focused Java harness, repository gates, hosted builds, and CodeQL.

## Boundaries

- Do not normalize, rewrite, or truncate accepted tweet text.
- Do not broaden the rejection to all right-to-left scripts or all format code
  points.
- Live Wear notification rendering remains a manual verification boundary.
