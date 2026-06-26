# Modern Platform Alternatives

## Scope

This guide maps the capabilities demonstrated by the retired Fabric,
TwitterKit, and legacy Wear APIs to current platform services. It is migration
planning guidance only: it does not migrate the historical samples, prove live
provider access, or make the vendored frameworks safe for production use.

The links below are primary provider documentation checked on June 25, 2026.
SDK versions, account access, pricing, quotas, and product terms can change, so
recheck them before implementing any stage. Keep the historical samples intact
until a separately reviewed replacement passes current toolchain, device, and
service validation.

## Capability Map

| Historical responsibility | Modern alternative | Security and ownership boundary | Minimum validation |
| --- | --- | --- | --- |
| Fabric crash collection | Firebase Crashlytics for Apple and Android projects | Each platform project owns its generated Firebase configuration. Keep service credentials, upload credentials, and machine-local configuration out of Git. | Build a dedicated non-production configuration, deliver one intentional test crash, confirm symbolication, and remove the trigger before release. |
| TwitterKit guest or user login | X OAuth 2.0 Authorization Code Flow with PKCE using a Native App/public client | Use an exact allowlisted redirect URI, `state`, an S256 code challenge, and only required scopes. A mobile app must not contain a confidential client secret. | Exercise success, cancellation, callback mismatch, stale state, denied scope, token expiry, and logout with a maintainer-owned test account. |
| TwitterKit tweet and user loading | X API v2 Post and User lookup | Treat API credentials and tokens as local or server-owned secrets according to the selected client model. Do not log raw responses or user-specific data. | Verify success, missing/deleted content, rate and authorization errors, malformed responses, cancellation, and UI publication on the correct thread. |
| Selected-tweet navigation when API access is unavailable | Existing validated HTTPS permalink browser fallback | Preserve canonical `twitter.com`/`x.com` host checks, no credentials or explicit port, ASCII handle/status grammar, and non-tweet rejection. | Run the standalone permalink policy matrix and verify navigation delegation without provider credentials. |
| Legacy phone-to-watch messaging | Wear OS Data Layer through current Google Play services | Use the Data Layer only between the paired app installations. Avoid logging message paths or payloads and do not treat the phone as a general network proxy. | Test connected, disconnected, duplicate, stale, malformed, oversized, and unavailable-node cases on supported phone/watch devices. |

## Crash Reporting

Use the current [Firebase Crashlytics setup
guide](https://firebase.google.com/docs/crashlytics/get-started) as the starting
point for a replacement. Configure Apple and Android projects independently,
keep generated provider files in the locations and access controls required by
the current Firebase instructions, and preserve this repository's rule that no
credential or upload secret is committed casually.

The WatchSample's historical force-crash control is not a production pattern.
Any Crashlytics test crash belongs in an isolated, non-production build and must
be removed or disabled before shipping. A dashboard event without symbols,
release metadata, and a matching test build is not sufficient migration
evidence.

## Authentication

Replace TwitterKit login with the [X OAuth 2.0 Authorization Code Flow with
PKCE](https://docs.x.com/fundamentals/authentication/oauth-2-0/authorization-code)
for a Native App/public client. Generate a fresh high-entropy verifier for each
attempt, send its S256 challenge, require the exact configured redirect URI,
and compare the returned `state` before exchanging the code. Request only the
scopes required by the sample, such as read-only post and user access when that
is the complete feature set.

Do not embed a confidential client secret in Android, Wear OS, iOS, or watchOS
code. Decide explicitly whether token exchange and refresh are performed by the
public client under the provider's current rules or by a separately secured
backend. Store tokens with current platform-protected storage, redact all auth
diagnostics, and define revocation and logout behavior before enabling users.

## Content Lookup and Fallback

Use X API v2 [Post lookup](https://docs.x.com/x-api/posts/lookup/introduction)
and [User lookup](https://docs.x.com/x-api/users/lookup/introduction) rather than
the TwitterKit object loaders. Define the minimum fields and expansions, model
missing or deleted content, and keep transport/provider errors separate from
rendering state. Recheck X API access and pricing before choosing an on-device
or backend-owned client architecture.

Where live API credentials or access are not available, keep the existing
credential-free browser fallback rather than weakening auth boundaries. The
fallback must continue to accept only validated HTTPS tweet permalinks; it is
not a substitute for authenticated API features or arbitrary web navigation.

## Wear OS Transport

Use the current [Wear OS Data Layer
overview](https://developer.android.com/training/wearables/data/overview) and
Google Play services APIs. `MessageClient` fits ephemeral commands or bounded
text delivery; `DataClient` fits state that must be synchronized and observed.
Keep `WearableListenerService` system-managed for background delivery instead
of adding a parallel application-owned listener lifecycle.

Preserve the current strict UTF-8 decoding, 1024-byte message boundary, empty
content rejection, and generic diagnostics unless a later product contract
changes them deliberately. Check Data Layer availability and node reachability,
and use each device's direct network access or a backend for cloud content when
that is the supported architecture instead of automatically proxying through
the phone.

## Staged Migration

1. **Freeze and inventory:** keep legacy dependency pins stable, revoke exposed
   historical credentials, inventory capabilities, and create maintainer-owned
   provider projects and test accounts outside source control.
2. **Establish current toolchains:** create separate modern build targets or
   successor samples with reproducible dependency manifests before changing
   runtime behavior.
3. **Replace crash reporting:** integrate and verify Firebase Crashlytics per
   platform without restoring the historical force-crash control.
4. **Replace auth and content:** implement PKCE, token lifecycle, X API v2 lookup,
   and the validated permalink fallback as independently testable boundaries.
5. **Replace Wear transport:** move the current payload policy behind the modern
   Data Layer clients and execute connected/disconnected device matrices.
6. **Retire legacy artifacts:** remove Fabric plugins, TwitterKit frameworks,
   and old transport dependencies only after feature, security, and cleanup
   parity is documented for every affected sample.

Each stage should be a focused PR. Do not combine provider migration with an
unrelated UI rewrite, and do not delete the historical implementation merely
because a new dependency compiles.

## Validation Gates

- **Static:** no literal credentials, no dynamic dependency selectors, exact
  callback configuration, minimal declared scopes, and preserved permalink,
  UTF-8, payload-size, logging, and listener-lifecycle contracts.
- **Build:** clean builds on documented current Apple and Android toolchains
  with reproducible dependency resolution and no vendored secret material.
- **Behavior:** success and hostile cases for auth, lookup, browser fallback,
  crash delivery, and phone/watch transport using maintainer-owned test data.
- **Privacy:** no raw tokens, API responses, tweet text, account data, message
  paths, or payloads in logs, crash metadata, screenshots, or PR artifacts.
- **Operations:** documented token revocation, provider-project ownership,
  dashboard access, quota/rate handling, rollback, and legacy artifact removal.

The existing `make check` remains the credential-free historical baseline. It
cannot prove current provider, simulator, device, dashboard, billing, or account
behavior; record those results in `docs/manual-sample-verification.md` when an
implementation migration is actually executed.
