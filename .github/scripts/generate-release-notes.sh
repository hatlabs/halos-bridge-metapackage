#!/bin/bash
# Generate release notes for a release
# Usage: generate-release-notes.sh <VERSION> <TAG_VERSION> <RELEASE_TYPE>
# RELEASE_TYPE: "prerelease", "draft", or "stable"

set -e

VERSION="${1:?Version required}"
TAG_VERSION="${2:?Tag version required}"
RELEASE_TYPE="${3:?Release type required}"

SHORT_SHA="${GITHUB_SHA:0:7}"

# Get the latest published (non-prerelease) release
LAST_TAG=$(gh release list --limit 100 --json tagName,isPrerelease,isDraft \
  --jq '.[] | select(.isDraft == false and .isPrerelease == false) | .tagName' | head -n1)

if [ -n "$LAST_TAG" ]; then
  echo "Generating changelog since $LAST_TAG"
  CHANGELOG=$(git log "${LAST_TAG}"..HEAD --pretty=format:"- %s (%h)" --no-merges --)
else
  echo "No previous published releases found, using recent commits"
  CHANGELOG=$(git log -10 --pretty=format:"- %s (%h)" --no-merges)
fi

case "$RELEASE_TYPE" in
  prerelease)
    cat > release_notes.md <<EOF
## HaLOS Bridge Metapackages ${TAG_VERSION} (Pre-release)

> **This is a pre-release build from the main branch. Use for testing only.**

Bridge packages that facilitate migration from \`apt.hatlabs.fi\` to \`apt.halos.fi\`.

**Packages:**
- \`halos\` - Bridge metapackage (adds apt.halos.fi source and GPG key)
- \`halos-marine\` - Bridge marine variant metapackage

**Build Information:**
- Commit: ${SHORT_SHA} (\`${GITHUB_SHA}\`)
- Built: $(date -u '+%Y-%m-%d %H:%M:%S UTC')

### Recent Changes

${CHANGELOG}

### Installation

\`\`\`bash
# Add Hat Labs repository (if not already added)
curl -fsSL https://apt.hatlabs.fi/hat-labs-apt-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/hatlabs-apt-key.gpg

# Add unstable channel
echo "deb [signed-by=/usr/share/keyrings/hatlabs-apt-key.gpg] https://apt.hatlabs.fi unstable main" | sudo tee /etc/apt/sources.list.d/hatlabs-unstable.list

# Update and install
sudo apt update
sudo apt install halos        # Base system
sudo apt install halos-marine # Marine variant
\`\`\`

EOF
    ;;

  draft)
    cat > release_notes.md <<EOF
## HaLOS Bridge Metapackages v${VERSION}

Bridge packages for migrating existing HaLOS installations from \`apt.hatlabs.fi\` to \`apt.halos.fi\`.

**How it works:**
1. \`apt upgrade\` installs bridge halos from apt.hatlabs.fi
2. Bridge postinst adds apt.halos.fi GPG key and APT source
3. Next \`apt update && apt upgrade\` upgrades to halos 0.3.0+ from apt.halos.fi

**Packages:**
- \`halos\` - Bridge metapackage (adds apt.halos.fi source and GPG key)
- \`halos-marine\` - Bridge marine variant metapackage

### Changes

${CHANGELOG}

### Installation

Available from [apt.hatlabs.fi](https://github.com/hatlabs/apt.hatlabs.fi):

\`\`\`bash
sudo apt update
sudo apt install halos        # Base system
sudo apt install halos-marine # Marine variant
\`\`\`
EOF
    ;;

  stable)
    cat > release_notes.md <<EOF
## HaLOS Bridge Metapackages v${VERSION}

Bridge packages for migrating existing HaLOS installations from \`apt.hatlabs.fi\` to \`apt.halos.fi\`.

**How it works:**
1. \`apt upgrade\` installs bridge halos from apt.hatlabs.fi
2. Bridge postinst adds apt.halos.fi GPG key and APT source
3. Next \`apt update && apt upgrade\` upgrades to halos 0.3.0+ from apt.halos.fi

**Packages:**
- \`halos\` - Bridge metapackage (adds apt.halos.fi source and GPG key)
- \`halos-marine\` - Bridge marine variant metapackage

### Changes

${CHANGELOG}

### Installation

Available from [apt.hatlabs.fi](https://github.com/hatlabs/apt.hatlabs.fi):

\`\`\`bash
sudo apt update
sudo apt install halos        # Base system
sudo apt install halos-marine # Marine variant
\`\`\`
EOF
    ;;

  *)
    echo "Error: Unknown RELEASE_TYPE '$RELEASE_TYPE'. Use 'prerelease', 'draft', or 'stable'"
    exit 1
    ;;
esac

echo "Release notes created"
