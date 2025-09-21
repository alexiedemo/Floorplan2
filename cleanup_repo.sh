#!/usr/bin/env bash
set -e
echo "Removing confusing Codemagic files inside subfolder (Codemagic uses root codemagic.yaml only)..."
rm -f CreateUseIphone/codemagic.yaml CreateUseIphone/codemagic-automatic.yaml CreateUseIphone/codemagic-fixed.yaml CreateUseIphone/codemagic-apple-sample.yaml CreateUseIphone/codemagic-custom-bundle.yaml || true

echo "Removing local ExportOptions plist files (workflow generates its own)..."
rm -f CreateUseIphone/ExportOptions.plist CreateUseIphone/ExportOptionsAutomatic.plist || true

echo "If these files are referenced in the Xcode project 'Sources' phase, please remove those entries in Xcode or with a follow-up patch."
echo "Done."
