## Fabric With Twitter Vision

Fabric With Twitter is a simple sample for integrating Fabric with Twitter.

The repository is useful as a historical TwitterKit/Fabric integration example,
with Android sample projects and setup notes in [`README.md`](README.md).

The goal is to keep the sample understandable while making credential handling
and legacy SDK status explicit.

The current focus is:

Priority:

- Preserve the Twitter integration tutorial structure
- Keep Android sample projects and Fabric setup recognizable
- Avoid committing Twitter keys, Fabric API keys, tokens, or signing material
- Keep legacy dependency assumptions visible

Next priorities:

- Add clearer build and verification notes for each sample app
- Replace dynamic dependencies with reproducible versions if the sample is revived
- Document modern alternatives to Fabric/TwitterKit
- Add small checks or manual steps for login/display behavior

Contribution rules:

- One PR = one focused auth, build, sample, or documentation change.
- Do not mix SDK migration with UI or behavior changes unless required.
- Keep credential placeholders empty in committed source.
- Verify Twitter login/display behavior with local credentials when changing it.

## Security

Twitter credentials and user sessions are sensitive. Real keys and tokens must
remain in local configuration or platform tooling and out of git.

Do not add logging that exposes tokens, account IDs, or private timeline data.

## What We Will Not Merge For Now

- Hardcoded Twitter/Fabric credentials
- Silent account actions
- Broad dependency migrations without verification notes
- Generated signing files or local machine paths
