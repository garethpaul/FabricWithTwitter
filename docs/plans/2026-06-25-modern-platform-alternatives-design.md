---
title: Modern Platform Alternatives Design
type: design
date: 2026-06-25
status: approved
execution: documentation
---

# Modern Platform Alternatives Design

## Status: Approved

## Problem

The repository explains how the retired Fabric and TwitterKit SDKs were wired
into Android, Wear OS, iOS, and watchOS samples, but it does not tell readers
which current platform capabilities replace those historical responsibilities.
A direct dependency rewrite would combine several unrelated migrations, require
live provider credentials, and make claims that cannot be verified with the
repository's retired toolchains.

## Evidence

- Firebase documents Crashlytics setup for current Apple and Android projects:
  <https://firebase.google.com/docs/crashlytics/get-started>
- X documents OAuth 2.0 Authorization Code Flow with PKCE for native public
  clients, including exact redirect URI matching and scoped access:
  <https://docs.x.com/fundamentals/authentication/oauth-2-0/authorization-code>
- X API v2 documents Post and User lookup endpoints:
  <https://docs.x.com/x-api/posts/lookup/introduction> and
  <https://docs.x.com/x-api/users/lookup/introduction>
- Android documents the current Wear OS Data Layer and its message, data, and
  listener clients:
  <https://developer.android.com/training/wearables/data/overview>

Provider access, pricing, SDK versions, and product terms can change. Anyone
implementing a migration must recheck the linked primary documentation first.

## Options

1. Rewrite every sample around current SDKs. This would produce runnable modern
   code eventually, but it is a broad product rewrite with credential, account,
   billing, UI, and device-test dependencies that this maintenance cycle cannot
   verify.
2. Add only an archival warning. This keeps the historical code untouched but
   leaves readers without an actionable capability map.
3. Document a staged replacement map while preserving the historical samples.
   Each capability gets an owner, security boundary, and validation gate, and no
   implementation claim is made before a separately verified migration.

## Decision

Use option 3. Map Fabric crash reporting to Firebase Crashlytics; TwitterKit
login to OAuth 2.0 Authorization Code Flow with PKCE for a native public client;
tweet and user loading to X API v2 Post and User lookup; and phone/watch
transport to the current Wear OS Data Layer. Retain the validated HTTPS tweet
permalink as a credential-free browser fallback where API access is unavailable.

## Boundaries

- Do not add provider credentials, client secrets, generated configuration, or
  account-specific identifiers to source control.
- Do not claim the legacy samples have been migrated or that current provider
  APIs are available without rechecking account access and terms.
- Do not remove vendored frameworks or legacy dependency pins until a separate
  implementation proves feature parity on supported toolchains and devices.
- Keep authentication, content lookup, crash reporting, and Wear transport as
  independently reviewable stages.
- Preserve existing permalink, payload-size, UTF-8, listener-lifecycle, logging,
  and redaction boundaries unless a later design explicitly replaces them.

## Validation

The documentation gate must require the modern alternatives guide, primary
source links, explicit non-implementation language, a staged migration order,
and synchronized README, security, vision, agent, and change-log references.
No live provider call or credential is required for this documentation change.
