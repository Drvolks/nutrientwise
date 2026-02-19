#!/bin/bash
# Archive and upload Nutrient Wise to TestFlight
#
# Requirements:
#   App Store Connect API key (.p8 file)
#   Apple Distribution certificate in local Keychain
#   Set these environment variables or edit the values below:
#     ASC_KEY_ID       - API Key ID
#     ASC_ISSUER_ID    - Issuer ID
#     ASC_KEY_PATH     - Path to AuthKey_XXXX.p8 file

set -e

# App Store Connect API key config
KEY_ID="${ASC_KEY_ID:?Set ASC_KEY_ID environment variable}"
ISSUER_ID="${ASC_ISSUER_ID:?Set ASC_ISSUER_ID environment variable}"
KEY_PATH="${ASC_KEY_PATH:?Set ASC_KEY_PATH environment variable}"

ARCHIVE_DIR=~/Library/Developer/Xcode/Archives/$(date +%Y-%m-%d)
EXPORT_DIR=/tmp/NutrientWise-export
PROJECT="Nutrient Wise.xcodeproj"
SCHEME="Nutrient Wise"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXPORT_PLIST="$SCRIPT_DIR/ExportOptions.plist"

AUTH_FLAGS=(-allowProvisioningUpdates \
  -authenticationKeyPath "$KEY_PATH" \
  -authenticationKeyID "$KEY_ID" \
  -authenticationKeyIssuerID "$ISSUER_ID")

rm -rf "$EXPORT_DIR"

# --- Bump build number ---

cd "$SCRIPT_DIR"
CURRENT_BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "Nutrient Wise/Nutrient Wise-Info.plist")
NEW_BUILD=$((CURRENT_BUILD + 1))
echo "=== Bumping build number: $CURRENT_BUILD → $NEW_BUILD ==="
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD" "Nutrient Wise/Nutrient Wise-Info.plist"

# --- Archive ---

echo "=== Archiving Nutrient Wise ==="
xcodebuild archive -project "$PROJECT" -scheme "$SCHEME" \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_DIR/NutrientWise.xcarchive" \
  "${AUTH_FLAGS[@]}"

# --- Export (sign for distribution) ---

echo "=== Exporting Nutrient Wise ==="
mkdir -p "$EXPORT_DIR"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_DIR/NutrientWise.xcarchive" \
  -exportOptionsPlist "$EXPORT_PLIST" \
  -exportPath "$EXPORT_DIR" \
  "${AUTH_FLAGS[@]}"

# --- Upload to TestFlight ---

echo "=== Uploading to TestFlight ==="
ARTIFACT=$(find "$EXPORT_DIR" \( -name "*.ipa" -o -name "*.pkg" \) -print -quit)
if [ -z "$ARTIFACT" ]; then
  echo "ERROR: No IPA found in $EXPORT_DIR"
  exit 1
fi

xcrun altool --upload-app \
  -f "$ARTIFACT" \
  -t ios \
  --apiKey "$KEY_ID" \
  --apiIssuer "$ISSUER_ID"

echo "=== Archived and uploaded to TestFlight ==="
