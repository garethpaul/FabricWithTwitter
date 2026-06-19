.PHONY: build check lint security test

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

check:
	@"$(ROOT)/scripts/check-baseline.sh"

lint: check

test: check

build: check

security: check
	@command -v gitleaks >/dev/null 2>&1 || { echo "gitleaks is required for make security" >&2; exit 1; }
	@cd "$(ROOT)" && gitleaks dir --no-banner --no-color --redact=100 --config "$(ROOT)/.gitleaks.toml" .
