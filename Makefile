# Makefile for RandyTime Garmin Watch App

# Variables (will be set after sourcing .envrc)
MONKEYC = $$(source .envrc && echo "$$GARMIN_SDK_HOME/bin/monkeyc")
MONKEYDO = $$(source .envrc && echo "$$GARMIN_SDK_HOME/bin/monkeydo")
DEVICE = instinct2
OUTPUT = RandyTime.prg
# Developer key path - set this in your environment or pass as argument
# Example: make build DEVELOPER_KEY=/path/to/your/developer_key
DEVELOPER_KEY ?= developer_key
JUNGLE_FILE = monkey.jungle

# Default target
.PHONY: all
all: build

# Build the application (debug version)
.PHONY: build
build:
	@echo "Building RandyTime for $(DEVICE)..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/monkeyc" -d $(DEVICE) -f $(JUNGLE_FILE) -o $(OUTPUT) -y $(DEVELOPER_KEY)
	@echo "Build complete: $(OUTPUT)"

# Build release version (no debug info, smaller file)
.PHONY: release
release:
	@echo "Building RandyTime RELEASE for $(DEVICE)..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/monkeyc" -d $(DEVICE) -f $(JUNGLE_FILE) -o $(OUTPUT) -y $(DEVELOPER_KEY) -r
	@echo "Release build complete: $(OUTPUT)"

# Run the application in simulator
.PHONY: run
run: build
	@echo "Starting Connect IQ simulator daemon..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/connectiq" &
	@echo "Waiting for simulator to initialize..."
	@sleep 5
	@echo "Running app in simulator for $(DEVICE)..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/monkeydo" $(OUTPUT) $(DEVICE) || echo "Simulator connection failed. Try running 'make restart' in a few seconds."
	@echo "App launched in simulator"

# Start just the simulator daemon
.PHONY: simulator
simulator:
	@echo "Starting Connect IQ simulator daemon..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/connectiq" &
	@echo "Simulator daemon started. Wait a few seconds before running app."

# Restart the application in simulator (without rebuilding)
.PHONY: restart
restart:
	@echo "Running app in simulator for $(DEVICE)..."
	@source .envrc && "$$GARMIN_SDK_HOME/bin/monkeydo" $(OUTPUT) $(DEVICE)
	@echo "App launched in simulator"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -f $(OUTPUT)
	rm -f *.prg.debug.xml
	@echo "Clean complete"

# Help target
.PHONY: help
help:
	@echo "RandyTime Garmin App - Makefile targets:"
	@echo "  make build   - Compile the application"
	@echo "  make run     - Build and run in simulator"
	@echo "  make restart - Run in simulator without rebuilding"
	@echo "  make clean   - Remove build artifacts"
	@echo "  make help    - Show this help message"
	@echo ""
	@echo "Required environment variable:"
	@echo "  GARMIN_SDK_HOME - Path to Connect IQ SDK"
	@echo ""
	@echo "Current settings:"
	@echo "  GARMIN_SDK_HOME = $(GARMIN_SDK_HOME)"
	@echo "  Device = $(DEVICE)"
	@echo "  Output = $(OUTPUT)"