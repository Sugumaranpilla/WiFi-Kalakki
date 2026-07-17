#!/bin/bash
# vedi_marunn.sh - dependency installer for pattas

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run parathooshanam as root (sudo ./vedi_marunn.sh)"
  exit 1
fi

echo "============================================="
echo "     PARATHOOSHANAM - DEPENDENCY INSTALLER      "
echo "============================================="
echo "[+] Preparing the gunpowder (vedi marunn)..."

# List of required packages for pattas to run
# wireless-tools -> provides iwconfig, used directly in pattas
# aircrack-ng    -> provides airodump-ng, airmon-ng, aireplay-ng, etc.
REQUIRED_PKGS=(aircrack-ng wireless-tools net-tools python3 python3-pip)

echo "[+] Updating package lists..."
if ! apt-get update -y; then
  echo "[-] Error: apt-get update failed. Check your network connection."
  exit 1
fi

echo "[+] Installing required packages: ${REQUIRED_PKGS[*]}"
if ! apt-get install -y "${REQUIRED_PKGS[@]}"; then
  echo "[-] Error: One or more packages failed to install."
  exit 1
fi

# Verify the binaries pattas actually depends on are present and working
echo -e "\n[+] Verifying installation..."
MISSING=0

check_bin() {
  local bin="$1"
  if ! command -v "$bin" > /dev/null 2>&1; then
    echo "    [-] Missing: $bin"
    MISSING=1
  else
    echo "    [+] Found:   $bin"
  fi
}


if [ "$MISSING" -eq 1 ]; then
  echo -e "\n[-] Some required tools are still missing. Please check the errors above."
  exit 1
fi

echo -e "\n[+] parathooshanam ready! You can now run wifi kalakki."
exit 0
