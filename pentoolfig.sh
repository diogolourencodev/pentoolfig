#!/bin/bash

# Function to execute commands
execc() {
    echo "Executing: $1"
    eval "$1"
}

# Create directories for storing tools
mkdir -p ~/Documents/Tools
mkdir ~/Documents/Tools/proxys
mkdir ~/Downloads

# Set up Kali Linux repositories (Uncomment if mirrors are not already configured)
sudo rm -r /etc/apt/sources.list
echo 'deb http://kali.download/kali kali-rolling main contrib non-free non-free-firmware\ndeb-src http://kali.download/kali kali-rolling main contrib non-free non-free-firmware' | sudo tee /etc/apt/sources.list

# Set DNS servers
echo "Configuring DNS servers..."
sudo rm -r /etc/resolv.conf
echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4' | sudo tee /etc/resolv.conf

# Creating better proxys configs
echo -e "dynamic_chain\nproxy_dns\nremote_dns_subnet 224\ntcp_read_time_out 15000\ntcp_connect_time_out 8000\n\n[ProxyList]\nhttp    104.244.75.218    8080\nsocks5  45.63.66.12       3128\nhttp    195.201.225.104   8080\nsocks5  88.99.10.252      1080\nhttp    200.252.206.177   8080\nhttp    177.101.182.38    3128\n\nsocks5  127.0.0.1         9050" | sudo tee ~/Documents/Tools/proxys/privoxy.conf

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y build-essential golang python3 python3-pip python3-dev python3-venv curl wget git unzip gcc make

# List of tools to install
tools=('nmap' 'nikto' 'sqlmap' 'whatweb' 'gobuster' 'ffuf' 'dirb' 'dirbuster' 
       'wpscan' 'dnsenum' 'dnsrecon' 'whois' 'theharvester' 'sublist3r' 
       'amass' 'metasploit-framework' 'hydra' 'john' 'hashcat' 'curl' 'wget'
       'netcat-openbsd' 'tcpdump' 'masscan' 'enum4linux' 'smbclient' 
       'smbmap' 'ldap-utils' 'feroxbuster' 'sslscan' 'wfuzz' 'xsser' 'recon-ng'
       'seclists' 'wordlists' 'wafw00f' 'subfinder' 'iptables' 'proxychains4' 'tor'
       'searchsploit' 'nuclei' 'firefox-esr' 'file')

# Install the listed tools
for tool in "${tools[@]}"; do
    echo "Installing $tool..."
    sudo apt install -y $tool
done

# List of Go tools to install
go_tools=("github.com/projectdiscovery/katana/cmd/katana" 
          "github.com/hahwul/dalfox/v2"
          "github.com/lc/gau/v2/cmd/gau"
          "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
          "github.com/tomnomnom/gf")

# Install Go tools
for tool in "${go_tools[@]}"; do
    echo "Installing Go tool $tool..."
    sudo go install $tool@latest
done

# Add Go to PATH
echo "Adding Go to PATH..."
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# Install pipx and other Python tools
echo "Installing pipx and other tools..."
sudo apt install -y pipx
pipx install uro

# Clone and install additional tools from GitHub
echo "Cloning GitHub repositories and installing additional tools..."

# 4-ZERO-3
git clone https://github.com/Dheerajmadhukar/4-ZERO-3 ~/Documents/Tools/4-ZERO-3
sudo chmod +x ~/Documents/Tools/4-ZERO-3/403-bypass.sh

git clone https://github.com/R3LI4NT/LFIscanner ~/Documents/Tools/LFIscanner
cd ~/Documents/Tools/LFIscanner
pip install -r requirements.txt --break-system-packages
cd ~

# ghauri
git clone https://github.com/r0oth3x49/ghauri ~/Documents/Tools/ghauri
cd ~/Documents/Tools/ghauri
pip install -r requirements.txt --break-system-packages
pip install setuptools --break-system-packages
sudo pip install setuptools --break-system-packages
sudo python3 setup.py install
cd ~

git clone https://github.com/gotr00t0day/spyhunt
cd ~/Documents/Tools/spyhunt
pip3 install -r requirements.txt --break-system-packages
sudo python3 install.py
cd ~

# Unzip rockyou wordlist if available
echo "Unzipping rockyou.txt.gz..."
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz

# Ensure the proper Kali repository exists
REPO_LINE="deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware"
if ! grep -Fxq "$REPO_LINE" /etc/apt/sources.list; then
    echo "Adding missing Kali repository to sources.list..."
    echo "$REPO_LINE" | sudo tee -a /etc/apt/sources.list
    sudo apt update
else
    echo "Kali repository already present. Continuing..."
fi

# BONUS: Install Micro Editor(the best)
sudo apt install micro -y
cd ~

# BONUS2: Install Burp Suite (run as 'burpsuite')
cd ~
sudo apt update
sudo apt install burpsuite -y

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y && sudo apt-get update && sudo apt-get upgrade -y

# Completion message
echo "Installation completed successfully!"

