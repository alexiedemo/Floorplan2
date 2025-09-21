#!/usr/bin/env bash
set -e
echo "Cleaning duplicate/legacy Codemagic and export files (safe to run multiple times)..."
rm -f CreateUseIphone/codemagic.yaml       CreateUseIphone/codemagic-automatic.yaml       CreateUseIphone/codemagic-fixed.yaml       CreateUseIphone/codemagic-apple-sample.yaml       CreateUseIphone/codemagic-custom-bundle.yaml       CreateUseIphone/ExportOptions.plist       CreateUseIphone/ExportOptionsAutomatic.plist || true
echo "Done."
