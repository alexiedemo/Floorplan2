markdown
# 🏗️ **IMMEDIATE FIX: Create App in App Store Connect**

## **Step 1: Create New App**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in **EXACTLY** as shown:

| Field | Value |
|-------|-------|
| **Platform** | iOS |
| **Name** | LiDAR Room Scanner |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | `io.codemagic.lidarscanner` |
| **SKU** | LIDAR_SCANNER_001 |
| **User Access** | Full Access |

⚠️ **CRITICAL**: The Bundle ID must be **exactly** `io.codemagic.lidarscanner` to match your Codemagic YAML file.

## **Step 2: Configure App Capabilities**
1. In your new app, go to **App Information**
2. Scroll to **App Store Connect** section
3. Add these capabilities:
   - ✅ ARKit
   - ✅ Camera
   - ✅ LiDAR Scanner

## **Step 3: Set Privacy Descriptions**
1. Go to **App Privacy** section
2. Add these usage descriptions:
   - **Camera**: "Camera access is required for LiDAR room scanning and 3D reconstruction."
   - **Location**: "Location is used to enhance AR tracking accuracy during room scanning."

## **Step 4: Verify Codemagic Integration**
1. In Codemagic, go to your app settings
2. Check **Integrations** → **App Store Connect**
3. Ensure it shows "Connected" status