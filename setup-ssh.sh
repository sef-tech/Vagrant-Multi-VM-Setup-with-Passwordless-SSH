#!/bin/bash
# This script sets up SSH key-based authentication between three Vagrant VMs: vm1, vm2, and vm3.
# It retrieves the public SSH keys from each VM and distributes them to the others' authorized_keys files.
# Finally, it tests the SSH connections to ensure everything is set up correctly.

# Usage: Run this script from the directory containing your Vagrantfile.

echo "==================================================="
echo "SSH Key Distribution Script for Vagrant VMs"
echo "==================================================="
echo ""

# Step 1: Verify all VMs are running
echo "Step 1: Verifying VMs are running..."
vagrant status | grep -E "(vm1|vm2|vm3)" | grep "running" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Not all VMs are running. Please run 'vagrant up' first."
    exit 1
fi
echo "✓ All VMs are running"
echo ""

# Step 2: Get public keys from each VM
echo "Step 2: Retrieving public keys from each VM..."
VM1_KEY=$(vagrant ssh vm1 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')
VM2_KEY=$(vagrant ssh vm2 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')
VM3_KEY=$(vagrant ssh vm3 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')

if [ -z "$VM1_KEY" ] || [ -z "$VM2_KEY" ] || [ -z "$VM3_KEY" ]; then
    echo "ERROR: Could not retrieve SSH keys from one or more VMs"
    echo "VM1 key present: $([ -n "$VM1_KEY" ] && echo 'Yes' || echo 'No')"
    echo "VM2 key present: $([ -n "$VM2_KEY" ] && echo 'Yes' || echo 'No')"
    echo "VM3 key present: $([ -n "$VM3_KEY" ] && echo 'Yes' || echo 'No')"
    exit 1
fi
echo "✓ Retrieved all public keys"
echo ""

# Step 3: Distribute keys
echo "Step 3: Distributing SSH keys..."

# Add keys to VM1 (avoid duplicates)
echo "  Adding keys to VM1..."
vagrant ssh vm1 -c "grep -qF '$VM2_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM2_KEY' >> ~/.ssh/authorized_keys; grep -qF '$VM3_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM3_KEY' >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
echo "  ✓ VM1 authorized keys updated"

# Add keys to VM2 (avoid duplicates)
echo "  Adding keys to VM2..."
vagrant ssh vm2 -c "grep -qF '$VM1_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM1_KEY' >> ~/.ssh/authorized_keys; grep -qF '$VM3_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM3_KEY' >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
echo "  ✓ VM2 authorized keys updated"

# Add keys to VM3 (avoid duplicates)
echo "  Adding keys to VM3..."
vagrant ssh vm3 -c "grep -qF '$VM1_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM1_KEY' >> ~/.ssh/authorized_keys; grep -qF '$VM2_KEY' ~/.ssh/authorized_keys 2>/dev/null || echo '$VM2_KEY' >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
echo "  ✓ VM3 authorized keys updated"

echo ""
echo "Step 4: Testing SSH connections..."
echo ""

# Test all connections
test_connection() {
    local from=$1
    local to=$2
    local result=$(vagrant ssh $from -c "ssh -o BatchMode=yes -o ConnectTimeout=5 vagrant@$to 'echo SUCCESS' 2>/dev/null" 2>/dev/null | grep SUCCESS)
    
    if [ -n "$result" ]; then
        echo "  ✓ $from -> $to: Connected"
        return 0
    else
        echo "  ✗ $from -> $to: Failed"
        return 1
    fi
}

test_connection "vm1" "vm2"
test_connection "vm1" "vm3"
test_connection "vm2" "vm1"
test_connection "vm2" "vm3"
test_connection "vm3" "vm1"
test_connection "vm3" "vm2"

echo ""
echo "==================================================="
echo "Setup Complete!"
echo "==================================================="
echo ""
echo "You can now SSH between VMs without passwords:"
echo "  vagrant ssh vm1"
echo "  Then inside vm1: ssh vm2"
echo "  Or: ssh vagrant@vm2"
echo ""