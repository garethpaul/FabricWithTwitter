.PHONY: build check lint security test

check:
	@scripts/check-baseline.sh

lint: check

test: check

build: check

security: check
	@command -v gitleaks >/dev/null 2>&1 || { echo "gitleaks is required for make security" >&2; exit 1; }
	@gitleaks dir --no-banner --no-color --redact=100 --config .gitleaks.toml .
