# Changes

## 2026-06-08

- Guarded Wear tweet message sending, notification display, and listener
  cleanup against missing payloads and disconnected clients.
- Added Google Maven to the legacy WearExample project so Wear support and Play
  Services artifacts resolve outside the old local SDK/JCenter paths.
- Replaced committed iOS Fabric run-script identifiers with local
  `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` environment variables.
- Added a static `make check` baseline for iOS Fabric scripts, Android
  Crashlytics placeholder keys, local credential ignores, and optional Xcode
  project listing.
- Documented local credential setup and verification boundaries for the legacy
  Android and iOS samples.
