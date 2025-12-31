#!/usr/bin/env bash
set -euo pipefail

REPO="nixos-uconsole/nixos-uconsole"
CACHE="nixos-clockworkpi-uconsole"

# Get version from git tags, or default to 0.1.0
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.1.0")
# Bump patch version: v0.1.0 -> v0.1.1
NEXT_VERSION=$(echo "$VERSION" | awk -F. '{$NF = $NF + 1;} 1' OFS=. | sed 's/^/v/' | sed 's/vv/v/')

echo "==> Building minimal image..."
nix build .#minimal 2>&1 | tee build.log

echo "==> Pushing to cachix..."
cachix push "$CACHE" result

echo "==> Compressing image..."
IMG_NAME="nixos-uconsole-cm4-${NEXT_VERSION}.img.zst"
zstd -T0 result/sd-image/*.img -o "$IMG_NAME"

echo "==> Creating release ${NEXT_VERSION}..."
gh release create "$NEXT_VERSION" \
  --repo "$REPO" \
  --title "$NEXT_VERSION" \
  --notes "NixOS uConsole CM4 image

Flash with:
\`\`\`
zstd -d ${IMG_NAME} -o nixos-uconsole.img
sudo dd if=nixos-uconsole.img of=/dev/sdX bs=4M status=progress
\`\`\`

Default login: \`uconsole\` / \`changeme\`
"

echo "==> Uploading image..."
gh release upload "$NEXT_VERSION" "$IMG_NAME" --repo "$REPO"

echo "==> Done! Release: https://github.com/${REPO}/releases/tag/${NEXT_VERSION}"
