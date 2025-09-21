markdown
# 🔧 Codemagic Setup Guide - LiDAR Room Scanner

## 🚨 **CRITICAL FIX: Bundle Identifier Issue**

The build failed because the bundle identifier `com.yourname.lidarroomscanner` doesn't have a matching provisioning profile. Here's how to fix it:

## ✅ **Solution 1: Use Codemagic's Bundle ID (Recommended)**

1. **Update Bundle Identifier** to: `com.codemagic.lidarroomscanner`
2. **Create App in App Store Connect** with this exact bundle ID
3. **Use automatic signing** (Codemagic handles provisioning)

## ✅ **Solution 2: Create Your Own Bundle ID**

### Step 1: Apple Developer Portal
1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** (Add new)
4. Select **App IDs** → **App**
5. Set **Bundle ID**: `com.yourname.lidarroomscanner` (or your preferred ID)
6. Enable capabilities:
   - ✅ **ARKit**
   - ✅ **Camera**

### Step 2: App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in details:
   - **Name**: LiDAR Room Scanner
   - **Bundle ID**: Select the one you created above
   - **SKU**: LIDAR_SCANNER_001
   - **User Access**: Full Access

### Step 3: Codemagic Configuration
1. In Codemagic, go to **App Settings**
2. Update **Bundle identifier** to match your App Store Connect app
3. Ensure **App Store Connect integration** is properly configured

## 🔑 **Environment Variables Setup**

In Codemagic, add these environment variables:

| Variable | Value | Where to Find |
|----------|-------|---------------|
| `APP_STORE_CONNECT_ISSUER_ID` | Your Issuer ID | App Store Connect → Users & Access → Keys |
| `APP_STORE_CONNECT_KEY_IDENTIFIER` | Your Key ID | Same as above (8-character string) |
| `APP_STORE_CONNECT_PRIVATE_KEY` | Upload .p8 file | Download from App Store Connect |

## 🛠 **Quick Fix Commands**

If you want to change the bundle ID in the YAML file: