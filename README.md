# 🌐 AccessX – Cyber Recon & Phishing Framework

![AccessX Banner](\Dev_File\Main Menu.png)

**All-in-One Ethical Security Testing Suite** - Complete package with Seeker, Strombreaker, and ngrok integration

Now access from ANY terminal:

bash
accessx  # Launches main interface

🔥 Key Features
Diagram
Code
pie
    title Feature Distribution
    "Automated Phishing Templates" : 35
    "Device Fingerprinting" : 25
    "Real-time Tracking" : 20
    "Ngrok Integration" : 15
    "Cross-Platform" : 5


📂 Repository Structure
AccessX/
├── Dev_File/
│   ├── accessx.sh (main executable)
│   ├── Tools/ (self-contained binaries)
│   │   ├── seeker/
│   │   ├── strombreaker/
│   │   └── ngrok/
│   └── Templates/
├── install.sh
└── uninstall.sh

⚡ Usage Flow
Launch: accessx

Select tool/module

Customize template (if needed)

Get shareable link

View real-time analytics

Diagram
Code

flowchart TD
    A[Start] --> B{Module}
    B -->|Seeker| C[Track Devices]
    B -->|Strombreaker| D[Phishing Sim]
    C & D --> E[Generate Link]
    E --> F[Share with Target]
    F --> G[Collect Data]

---

## 🚀 Instant Setup & Launch

```bash
# Install system-wide (Linux/macOS)
git clone https://github.com/rakibhassan66/AccessX.git
cd AccessX && sudo ./install.sh

# Windows (Run as Admin):
iwr -useb https://bit.ly/accessx-win | iex


