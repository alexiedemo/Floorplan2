# Floorplan2 → Codemagic Fix Pack

This pack gives you:
- A clean, root-level `codemagic.yaml` (Simulator + TestFlight)
- A shared scheme `CI-Auto.xcscheme` pinned to your real app target (`CreateUseIphone`, GUID `2F516EA70C3BD498`)
- Optional `cleanup_repo.sh` to remove duplicate YAMLs / ExportOptions files from the app folder

## Install

1) Unzip into your repo **root** so files land exactly at:
   - `./codemagic.yaml`
   - `./CreateUseIphone.xcodeproj/xcshareddata/xcschemes/CI-Auto.xcscheme`
   - `./cleanup_repo.sh`

2) (Optional) Run cleanup:
   ```bash
   bash cleanup_repo.sh
   ```

3) Commit & push:
   ```bash
   git add codemagic.yaml CreateUseIphone.xcodeproj/xcshareddata/xcschemes/CI-Auto.xcscheme cleanup_repo.sh
   git commit -m "Codemagic: clean root YAML + pinned shared scheme"
   git push
   ```

4) In **Codemagic → Environment variables (Secure)**, set:
   - `APP_STORE_CONNECT_PRIVATE_KEY` → paste the full contents of your `.p8` key

5) Run these workflows:
   - **iOS • Simulator (Quick Launch)**
   - **iOS • TestFlight (Automatic Signing)**

> Notes
> - YAML uses workspace: `./CreateUseIphone.xcodeproj/project.xcworkspace`
> - Scheme forced to: `CI-Auto` (you can switch to `CreateUseIphone` later if you prefer)
> - Bundle ID normalised to: `com.codemagic.lidarroomscanner`
