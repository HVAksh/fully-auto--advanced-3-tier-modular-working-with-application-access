#!/bin/bash

set -e  # Exit on any error

# ================================================================
# Utility Functions
# ================================================================

print_section() {
    echo "================================================"
    echo " $1"
    echo "================================================"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 is required but not installed."
        exit 1
    fi
}

# ================================================================
# Pre-checks
# ================================================================
check_command terraform
check_command packer
check_command aws
check_command jq

# ================================================================
#  AMI Creation (Frontend + Backend)
# ================================================================
print_section "Creating AMIs"

check_ami_exists() {
    local ami_id=$1
    if [ ! -z "$ami_id" ]; then
        aws ec2 describe-images \
            --image-ids "$ami_id" \
            --query 'Images[0].State' \
            --output text 2>/dev/null | grep -q "available"
        return $?
    fi
    return 1
}

# --- Frontend AMI ---
print_section "Checking Frontend AMI"
FRONTEND_AMI_ID=""
if [ -f "terraform/compute/ami_ids/frontend_ami.txt" ]; then
    FRONTEND_AMI_ID=$(cat terraform/compute/ami_ids/frontend_ami.txt)
fi

if check_ami_exists "$FRONTEND_AMI_ID"; then
    echo "✅ Frontend AMI $FRONTEND_AMI_ID already exists"
else
    echo "🚀 Building new Frontend AMI..."
    cd packer/frontend
    chmod +x ./build_ami.sh
    ./build_ami.sh
    cd ../..
fi

# --- Backend AMI ---
print_section "Checking Backend AMI"
BACKEND_AMI_ID=""
if [ -f "terraform/compute/ami_ids/backend_ami.txt" ]; then
    BACKEND_AMI_ID=$(cat terraform/compute/ami_ids/backend_ami.txt)
fi

if check_ami_exists "$BACKEND_AMI_ID"; then
    echo "✅ Backend AMI $BACKEND_AMI_ID already exists"
else
    echo "🚀 Building new Backend AMI..."
    cd packer/backend
    chmod +x ./build_ami.sh
    ./build_ami.sh
    cd ../..
fi
