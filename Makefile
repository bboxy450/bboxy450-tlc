# Generated canonical standalone interface by bboxy450-term/scripts/prepare-tlc.py.
# Policy: https://github.com/bboxy450/bboxy450-tlc/blob/main/ATTRIBUTION.md
SHELL := /bin/sh
TARGET_DIR ?= target
export CARGO_BUILD_JOBS := 2
.PHONY: test test-formal test-licenses check-license-packages
test: test-licenses
	cargo test --locked --target-dir '$(TARGET_DIR)'
	cargo clippy --locked --all-targets --target-dir '$(TARGET_DIR)' -- -D warnings
	$(MAKE) test-formal TARGET_DIR='$(TARGET_DIR)'
test-licenses:
	python3 -I scripts/suite-licenses.py
	python3 -I scripts/test-suite-licenses.py
check-license-packages: test-licenses
	python3 -I scripts/suite-licenses.py --packages
test-formal:
	python3 -I scripts/test-formal.py
	cargo run --locked --example verify --target-dir '$(TARGET_DIR)' -- '$(abspath $(TARGET_DIR))/formal/models'
	python3 -I scripts/formal.py --target '$(abspath $(TARGET_DIR))/formal'
