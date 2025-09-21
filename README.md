# RoomScan Pro – Cairns — CubiCasa‑style Scanner (Codemagic‑ready, v2)

Branding for Cairns real estate, onboarding, settings (metric/imperial), JSON/CSV/PDF/SVG export, RoomPlan scaffold, and a clean Codemagic pipeline.

## Deploy
```bash
unzip roomscan-pro-v2.zip -d .
git add .
git commit -m "Add RoomScan Pro v2 (Codemagic-ready)"
git push
```

In Codemagic → **Environment variables (Secure)** set:
- `APP_STORE_CONNECT_PRIVATE_KEY` → paste the full contents of your .p8

Run workflows:
- **iOS • Simulator (Quick Launch)**
- **iOS • TestFlight (Automatic Signing)**
