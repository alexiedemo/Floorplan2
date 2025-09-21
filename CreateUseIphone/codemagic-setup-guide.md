markdown
# 🚀 Codemagic Setup Guide for LiDAR Room Scanner

## Prerequisites

1. **Apple Developer Account** with App Store Connect access
2. **Codemagic Account** (free tier available)
3. **App Store Connect API Key** for integration

## Step-by-Step Setup

### 1. Create App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys**
3. Click **Generate API Key**
4. Set **Access Level** to **Developer** or **Admin**
5. Download the `.p8` key file
6. Note down:
   - **Key ID** (8-character string)
   - **Issuer ID** (UUID format)

### 2. Configure Codemagic Integration

1. Go to **Codemagic Dashboard** → **Integrations**
2. Click **App Store Connect**
3. Enter:
   - **Integration Name**: `codemagic_app_store_connect`
   - **Issuer ID**: Your App Store Connect Issuer ID
   - **Key ID**: Your API Key ID
   - **Private Key**: Upload your `.p8` file
4. Save the integration

### 3. Set Up Code Signing

#### Option A: Automatic Signing (Recommended)