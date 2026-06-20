.PHONY: build check lint security test

override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SWIFTC ?= swiftc
JAVAC ?= javac
JAVA ?= java

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-ios-tweet-permalink-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable iOS tweet permalink policy tests skipped"; \
	fi
	@if "$(JAVAC)" -version >/dev/null 2>&1 && "$(JAVA)" -version >/dev/null 2>&1; then \
		JAVAC="$(JAVAC)" JAVA="$(JAVA)" "$(ROOT)/scripts/run-wear-message-policy-tests.sh"; \
	else \
		echo "Java runtime unavailable; executable Wear message policy tests skipped"; \
	fi
	@"$(ROOT)/scripts/check-baseline.sh"

lint: check

test: check

build: check

security: check
	@command -v gitleaks >/dev/null 2>&1 || { echo "gitleaks is required for make security" >&2; exit 1; }
	@cd "$(ROOT)" && gitleaks dir --no-banner --no-color --redact=100 --config "$(ROOT)/.gitleaks.toml" .
