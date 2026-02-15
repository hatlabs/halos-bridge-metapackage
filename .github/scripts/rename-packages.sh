#!/bin/bash
set -euo pipefail

# Rename both halos and halos-marine packages with distro+component suffix
# Usage: rename-packages.sh --version <debian-version> --distro <distro> --component <component>
# Example: rename-packages.sh --version 0.2.0-1 --distro trixie --component main

VERSION=""
DISTRO=""
COMPONENT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --distro)
            DISTRO="$2"
            shift 2
            ;;
        --component)
            COMPONENT="$2"
            shift 2
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            echo "Usage: $0 --version <version> --distro <distro> --component <component>" >&2
            exit 1
            ;;
    esac
done

if [ -z "$VERSION" ] || [ -z "$DISTRO" ] || [ -z "$COMPONENT" ]; then
    echo "Error: --version, --distro, and --component are required" >&2
    echo "Usage: $0 --version <version> --distro <distro> --component <component>" >&2
    exit 1
fi

# Packages to rename
PACKAGES=("halos" "halos-marine")

for PKG in "${PACKAGES[@]}"; do
    OLD_NAME="${PKG}_${VERSION}_all.deb"
    NEW_NAME="${PKG}_${VERSION}_all+${DISTRO}+${COMPONENT}.deb"

    if [ -f "$OLD_NAME" ]; then
        echo "Renaming package: $OLD_NAME -> $NEW_NAME"
        mv "$OLD_NAME" "$NEW_NAME"
    else
        echo "Error: Expected package not found: $OLD_NAME" >&2
        FAILED=1
    fi
done

if [ "${FAILED:-0}" -eq 1 ]; then
    echo "Error: One or more packages were not found" >&2
    exit 1
fi

echo "Package renaming complete"
ls -lh *.deb 2>/dev/null || echo "No .deb files found"
