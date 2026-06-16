.PHONY: build check lint test

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SWIFTC ?= swiftc

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-ios-tweet-permalink-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable iOS tweet permalink policy tests skipped"; \
	fi
	@"$(ROOT)/scripts/check-baseline.sh"

lint: check

test: check

build: check
