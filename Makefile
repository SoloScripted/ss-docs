# Makefile for managing the Jekyll site located in the /docs directory.

# Variables
JEKYLL_CMD = bundle exec jekyll
SOURCE_DIR = docs

.PHONY: all build serve clean doctor install help lint release

all: help

# Installs the required Ruby gems using Bundler.
install:
	@echo "--> Installing dependencies from Gemfile..."
	cd $(SOURCE_DIR) && bundle install

# Builds the Jekyll site from the docs/ directory.
build:
	@echo "--> Building Jekyll site..."
	cd $(SOURCE_DIR) && $(JEKYLL_CMD) build

# Serves the site locally with live-reloading.
# Access it at http://localhost:4000
serve:
	@echo "--> Starting Jekyll server at http://localhost:4000"
	@echo "    Press Ctrl+C to stop."
	cd $(SOURCE_DIR) && $(JEKYLL_CMD) serve --livereload

# Removes the generated site and Jekyll metadata.
clean:
	@echo "--> Cleaning the site..."
	cd $(SOURCE_DIR) && $(JEKYLL_CMD) clean

# Checks the site for any configuration problems.
doctor:
	@echo "--> Checking for site configuration issues..."
	cd $(SOURCE_DIR) && $(JEKYLL_CMD) doctor

# Lints the generated HTML for issues like broken links and missing alt tags.
lint: doctor
	@echo "--> Linting the generated HTML in docs/_site..."
	cd $(SOURCE_DIR) && bundle exec htmlproofer ./_site --disable_external true

# Creates a new git tag and pushes it to the remote origin to trigger a release.
# Usage: make release TAG=vX.Y.Z
release:
	@if [ -z "$(TAG)" ]; then \
		echo "Error: TAG is not set."; \
		echo "Usage: make release TAG=vX.Y.Z"; \
		exit 1; \
	fi
	@if ! git diff-index --quiet HEAD --; then \
		echo "Error: Working directory is not clean. Please commit or stash your changes before tagging."; \
		exit 1; \
	fi
	@if git rev-parse -q --verify "refs/tags/$(TAG)" >/dev/null; then \
		echo "Error: Tag $(TAG) already exists."; \
		exit 1; \
	fi
	@echo "--> Creating and pushing tag $(TAG)..."
	@git tag $(TAG)
	@git push origin $(TAG)
	@echo "--> Tag $(TAG) has been created and pushed. This will trigger the release workflow."

# Displays this help message.
help:
	@echo "Available targets:"
	@echo "  install - Install dependencies"
	@echo "  build   - Build the site"
	@echo "  serve   - Serve the site locally with live-reload"
	@echo "  clean   - Remove generated files"
	@echo "  doctor  - Check for site configuration issues"
	@echo "  lint    - Lint the generated HTML"
	@echo "  release - Tag and push a new release (e.g., TAG=v1.0.0)"
	@echo "  help    - Show this help message"
