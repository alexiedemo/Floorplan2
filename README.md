# RoomScan Pro — CubiCasa‑style Scanner (Codemagic‑ready)

- Bundle ID: `com.codemagic.lidarroomscanner`
- Scheme: `CI-Auto`
- Workspace: `./CreateUseIphone.xcodeproj/project.xcworkspace`

## Features
- SwiftUI app with simple Home → Scan → Editor → Export flow
- **RoomPlan integration** (iOS 17+, on LiDAR devices) via conditional import
- **SVG/PDF export** for floorplans
- Local JSON storage for saved plans

## Use with Codemagic
1. Unzip in your repo root and commit:
   ```bash
   unzip roomscan-pro-full.zip -d .
   git add .
   git commit -m "Add RoomScan Pro (Codemagic-ready)"
   git push
   ```
2. In Codemagic → **Environment variables (Secure)** set:
   - `APP_STORE_CONNECT_PRIVATE_KEY` → paste your `.p8` contents
3. Run:
   - **iOS • Simulator (Quick Launch)**
   - **iOS • TestFlight (Automatic Signing)**

> You can change the bundle id in `Info.plist` and in `codemagic.yaml` if needed.
