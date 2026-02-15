# HaLOS Bridge Metapackages

Temporary bridge packages that facilitate migration of existing HaLOS installations from `apt.hatlabs.fi` to `apt.halos.fi`.

## How It Works

1. Existing HaLOS devices have `apt.hatlabs.fi` configured as their APT source
2. `apt upgrade` installs bridge `halos` 0.2.11 from apt.hatlabs.fi
3. Bridge postinst script adds the `apt.halos.fi` GPG key and APT source
4. Next `apt update && apt upgrade` upgrades to `halos` 0.3.0+ from apt.halos.fi
5. From that point on, all updates come from apt.halos.fi

## Packages

- **`halos`** - Bridge metapackage with identical dependencies to halos 0.2.10, plus a postinst that installs the apt.halos.fi source
- **`halos-marine`** - Bridge marine variant with identical dependencies to halos-marine 0.2.10

## Temporary Nature

These bridge packages exist solely for the APT repository migration. Once all devices have migrated to apt.halos.fi, this repository can be archived.

## Development

```bash
# Build packages locally
./run build-all

# Lint packages
./run lint

# Bump version
./run bumpversion patch
```

## CI/CD

Uses the standard pr-main-release workflow via `hatlabs/shared-workflows`:

- **PR** - Tests (build verification) + lintian + version bump check
- **Merge to main** - Build .deb, create pre-release, dispatch to apt.hatlabs.fi unstable
- **Publish release** - Dispatch to apt.hatlabs.fi stable
