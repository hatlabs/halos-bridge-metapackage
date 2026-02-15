# HaLOS Bridge Metapackages - Agentic Coding Guide

**LAST MODIFIED**: 2026-02-15

## For Agentic Coding: Use the HaLOS Workspace

**IMPORTANT**: Work from the halos workspace for full context.

## About This Project

Temporary bridge Debian metapackages for migrating existing HaLOS installations from `apt.hatlabs.fi` to `apt.halos.fi`. Contains two packages:
- `halos` - Bridge base system (identical deps to 0.2.10, postinst adds apt.halos.fi)
- `halos-marine` - Bridge marine variant (identical deps to 0.2.10)

## Quick Start

```bash
# Build packages
./run build-all

# Lint
./run lint
```

## Structure

```
halos-bridge-metapackage/
├── VERSION                 # Upstream version
├── halos/debian/          # halos bridge package
├── halos/keys/            # GPG key for apt.halos.fi
├── halos-marine/debian/   # halos-marine bridge package
├── docker/                # Build environment
└── .github/               # CI/CD workflows
```

## Git Workflow

**MANDATORY**: PRs must have all checks passing before merging.

**Branch Workflow**: Never push to main - use feature branches and PRs.

See `halos/docs/DEVELOPMENT_WORKFLOW.md` for detailed workflows.

## Version Management

Version bumping uses `bump2version` (consistent with other HaLOS repos).
`debian/changelog` files are tracked in git. CI overwrites them during release builds with the correct revision.

### Bumping Versions

```bash
# Bump patch version (0.2.11 -> 0.2.12)
./run bumpversion patch

# Push the automatically created commit
git push
```

Requires `bump2version` installed (`pip install bump2version`).

**CI Enforcement**: PRs that change package-affecting files must include a VERSION bump or CI will fail.
