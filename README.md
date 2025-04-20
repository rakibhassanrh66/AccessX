# 🌐 AccessX – Cyber Recon & Phishing Framework

![AccessX Banner](Dev_File/Main%20Menu.png)

**All-in-One Ethical Security Testing Suite** – Complete package with Seeker, Strombreaker, and Ngrok integration

---

## ⚙️ Launch from ANY terminal:

```bash
accessx  # Launches main interface

pie
    title Feature Distribution
    "Automated Phishing Templates" : 35
    "Device Fingerprinting" : 25
    "Real-time Tracking" : 20
    "Ngrok Integration" : 15
    "Cross-Platform" : 5

AccessX/
├── Dev_File/
│   ├── accessx.sh              # Main launcher script
│   ├── Tools/                  # Self-contained tools
│   │   ├── seeker/
│   │   ├── strombreaker/
│   │   └── ngrok/
│   └── Templates/              # Phishing and recon templates
├── install.sh
└── uninstall.sh


flowchart TD
    A[Start] --> B{Choose Module}
    B -->|Seeker| C[Track Devices]
    B -->|Strombreaker| D[Phishing Simulation]
    C & D --> E[Generate Link]
    E --> F[Share with Target]
    F --> G[Collect Data]

# Linux/macOS (System-wide install)
git clone https://github.com/rakibhassan66/AccessX.git
cd AccessX && sudo ./install.sh

# Windows (Run in PowerShell as Admin)
iwr -useb https://bit.ly/accessx-win | iex


