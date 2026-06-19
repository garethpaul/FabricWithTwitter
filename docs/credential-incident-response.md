# Credential Incident Response

## Confirmed Exposure

The tracked TableView iOS `Info.plist` contained a literal Fabric API key and
literal Twitter consumer key/secret from commit
`fa70307f25c152c9958262b36a159393de5aff3d` on November 29, 2014 until the
credential-remediation change on June 19, 2026. The values are intentionally
omitted from this document and from review output.

A removed historical checker also embedded the corresponding Fabric build
secret in commit `6dd16a067a57ca8a74c33b1870bca40e1406ff26`. A redacted
Gitleaks history scan confirms four distinct credential findings across these
two historical paths.

Replacing the current files with inert build-setting placeholders prevents new
builds from reading the committed values, but it does not remove them from Git
history, existing clones, forks, caches, or old pull-request refs. Treat all
four historical values as publicly disclosed.

## Required Repository-Owner Action

Provider access is required for the following actions; repository automation
cannot perform them:

1. Revoke the exposed Fabric API key/build secret and Twitter consumer
   key/secret, or delete the retired provider applications if revocation is the
   only supported path.
2. Review provider-side activity and audit records for unexpected use from the
   original exposure date through the revocation time.
3. Create replacement credentials only if a controlled legacy test still needs
   them, grant the least privilege available, and store them only in ignored
   local configuration such as `Config/LocalSecrets.xcconfig`.
4. Invalidate any downstream tokens or integrations derived from the exposed
   consumer credentials when the provider still offers that control.

History rewriting may reduce accidental rediscovery in this repository, but it
cannot revoke copied credentials and must not delay provider-side revocation.
If history is rewritten, coordinate the force-push and clone/fork cleanup as a
separate maintenance operation after rotation.

## Repository Controls

- The tracked plist uses exact inert build-setting placeholders.
- Populated local `.xcconfig` files remain ignored.
- `make security` runs the credential-boundary tests and a redacted Gitleaks
  current-tree scan.
- CI installs a version- and checksum-pinned Gitleaks binary and does not
  persist checkout credentials.
- Review and incident reports must never print the historical values.
