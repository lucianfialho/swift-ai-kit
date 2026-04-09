#!/bin/bash
set -e

APP_NAME="MyApp"
SCHEME="MyApp"
BUILD_DIR="build"
DMG_NAME="${APP_NAME}.dmg"

echo "Building ${APP_NAME}..."
xcodebuild archive \
  -scheme "${SCHEME}" \
  -configuration Release \
  -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGN_STYLE=Manual \
  2>&1 | grep -E "error:|archive"

xcodebuild -exportArchive \
  -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
  -exportPath "${BUILD_DIR}" \
  -exportOptionsPlist scripts/ExportOptions.plist

echo "Creating DMG..."
hdiutil create -volname "${APP_NAME}" \
  -srcfolder "${BUILD_DIR}/${APP_NAME}.app" \
  -ov -format UDZO \
  "${DMG_NAME}"

echo "Done: ${DMG_NAME}"
