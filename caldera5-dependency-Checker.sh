#Author:Shafeek
#Date:2024-OCT-25

#!/bin/bash

# Minimum required versions
REQUIRED_PYTHON_VERSION="3.8"
REQUIRED_NODE_VERSION="16.0"
REQUIRED_GOLANG_VERSION="1.19"
REQUIRED_RAM_GB=8
REQUIRED_CPUS=2
REQUIRED_BROWSER="google-chrome"
DEFAULT_BROWSER="mozila-firefox"

# Array to store check results
declare -a CHECK_RESULTS

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# Check for Python version
check_python() {
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        if [[ $(echo -e "$PYTHON_VERSION\n$REQUIRED_PYTHON_VERSION" | sort -V | head -n1) == "$REQUIRED_PYTHON_VERSION" ]]; then
            CHECK_RESULTS+=("${GREEN}Python version $PYTHON_VERSION meets the requirement.${NC}")
        else
            CHECK_RESULTS+=("${RED}Python version $PYTHON_VERSION does NOT meet the requirement. Required: $REQUIRED_PYTHON_VERSION+.${NC}")
        fi
    else
        CHECK_RESULTS+=("${RED}Python is not installed. Install with: sudo apt install python3${NC}")
    fi
}

# Check for pip3
check_pip() {
    if command -v pip3 &>/dev/null; then
        CHECK_RESULTS+=("${GREEN}pip3 is installed.${NC}")
    else
        CHECK_RESULTS+=("${RED}pip3 is not installed. Install with: sudo apt install python3-pip${NC}")
    fi
}

# Check for NodeJS version
check_node() {
    if command -v node &>/dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//')
        if [[ $(echo -e "$NODE_VERSION\n$REQUIRED_NODE_VERSION" | sort -V | head -n1) == "$REQUIRED_NODE_VERSION" ]]; then
            CHECK_RESULTS+=("${GREEN}NodeJS version $NODE_VERSION meets the requirement.${NC}")
        else
            CHECK_RESULTS+=("${RED}NodeJS version $NODE_VERSION does NOT meet the requirement. Required: $REQUIRED_NODE_VERSION+. Install latest version with: curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt install -y nodejs${NC}")
        fi
    else
        CHECK_RESULTS+=("${RED}NodeJS is not installed. Install with: curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt install -y nodejs${NC}")
    fi
}

# Check for npm
check_npm() {
    if command -v npm &>/dev/null; then
        CHECK_RESULTS+=("${GREEN}npm is installed.${NC}")
    else
        CHECK_RESULTS+=("${RED}npm is not installed. Install with: sudo apt install npm${NC}")
    fi
}

# Check for GoLang version
check_golang() {
    if command -v go &>/dev/null; then
        GOLANG_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        if [[ $(echo -e "$GOLANG_VERSION\n$REQUIRED_GOLANG_VERSION" | sort -V | head -n1) == "$REQUIRED_GOLANG_VERSION" ]]; then
            CHECK_RESULTS+=("${GREEN}GoLang version $GOLANG_VERSION meets the recommendation.${NC}")
        else
            CHECK_RESULTS+=("${BLUE}GoLang version $GOLANG_VERSION does NOT meet the recommendation. Recommended: $REQUIRED_GOLANG_VERSION+. Install latest version with: sudo apt install golang${NC}")
        fi
    else
        CHECK_RESULTS+=("${RED}GoLang is not installed. Install with: sudo apt install golang${NC}")
    fi
}

# Check for system memory
check_memory() {
    RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    RAM_GB=$((RAM / 1024 / 1024))
    if (( RAM_GB >= REQUIRED_RAM_GB )); then
        CHECK_RESULTS+=("${GREEN}RAM: $RAM_GB GB meets the requirement.${NC}")
    else
        CHECK_RESULTS+=("${RED}RAM: $RAM_GB GB does NOT meet the requirement. Required: ${REQUIRED_RAM_GB}GB+.${NC}")
    fi
}

# Check for CPU count
check_cpu() {
    CPUS=$(nproc)
    if (( CPUS >= REQUIRED_CPUS )); then
        CHECK_RESULTS+=("${GREEN}CPU count: $CPUS meets the requirement.${NC}")
    else
        CHECK_RESULTS+=("${RED}CPU count: $CPUS does NOT meet the requirement. Required: ${REQUIRED_CPUS}+.${NC}")
    fi
}

# Check for recommended browser
check_browser() {
    if command -v "$REQUIRED_BROWSER" &>/dev/null; then
        CHECK_RESULTS+=("${GREEN}Browser $REQUIRED_BROWSER is installed.${NC}")
    else
        CHECK_RESULTS+=("${RED}Browser $REQUIRED_BROWSER is NOT installed. Install with: sudo apt install google-chrome-stable${NC}")
    fi
}

# Run checks
echo "Checking system requirements for Caldera..."
check_python
check_pip
check_node
check_npm
check_golang
check_memory
check_cpu
check_browser

# Display summary of all checks
echo -e "\n===== Summary of Checks ====="
for result in "${CHECK_RESULTS[@]}"; do
    echo -e "$result"
done
echo "============================="

# To Add OS Check,suppoorted only linux and mac

