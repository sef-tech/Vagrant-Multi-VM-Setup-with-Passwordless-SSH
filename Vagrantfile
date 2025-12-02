# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Define common settings
  config.vm.box = "bento/ubuntu-24.04"
  
  # ============================================================
  # VM 1 Configuration
  # ============================================================
  config.vm.define "vm1" do |vm1|
    vm1.vm.hostname = "omni-1"
    vm1.vm.network "private_network", ip: "192.168.56.101"
    vm1.vm.network "public_network"
    
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = "Omni-VM1"
      vb.memory = "1024"
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--groups", "/Main-VMs"]
    end
    
    vm1.vm.provision "shell", inline: <<-SHELL
      apt-get update -qq
      systemctl enable ssh
      systemctl start ssh
      
      # Add other VMs to hosts file
      echo "192.168.56.102 vm2" >> /etc/hosts
      echo "192.168.56.103 vm3" >> /etc/hosts
      
      # Generate SSH key if not exists
      if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
        sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
      fi
      
      # Ensure authorized_keys exists with correct permissions
      sudo -u vagrant touch /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
      
      # Configure SSH client to not ask for host verification
      sudo -u vagrant cat > /home/vagrant/.ssh/config <<EOF
Host 192.168.56.* vm1 vm2 vm3
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOF
      chmod 600 /home/vagrant/.ssh/config
      chown vagrant:vagrant /home/vagrant/.ssh/config
      
      echo "✅ VM1 provisioned successfully!"
    SHELL
  end
  
  # ============================================================
  # VM 2 Configuration
  # ============================================================
  config.vm.define "vm2" do |vm2|
    vm2.vm.hostname = "omni-2"
    vm2.vm.network "private_network", ip: "192.168.56.102"
    vm2.vm.network "public_network"
    
    vm2.vm.provider "virtualbox" do |vb|
      vb.name = "Omni-VM2"
      vb.memory = "1024"
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--groups", "/Main-VMs"]
    end
    
    vm2.vm.provision "shell", inline: <<-SHELL
      apt-get update -qq
      systemctl enable ssh
      systemctl start ssh
      
      # Add other VMs to hosts file
      echo "192.168.56.101 vm1" >> /etc/hosts
      echo "192.168.56.103 vm3" >> /etc/hosts
      
      # Generate SSH key if not exists
      if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
        sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
      fi
      
      # Ensure authorized_keys exists with correct permissions
      sudo -u vagrant touch /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
      
      # Configure SSH client
      sudo -u vagrant cat > /home/vagrant/.ssh/config <<EOF
Host 192.168.56.* vm1 vm2 vm3
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOF
      chmod 600 /home/vagrant/.ssh/config
      chown vagrant:vagrant /home/vagrant/.ssh/config
      
      echo "✅ VM2 provisioned successfully!"
    SHELL
  end
  
  # ============================================================
  # VM 3 Configuration
  # ============================================================
  config.vm.define "vm3" do |vm3|
    vm3.vm.hostname = "omni-3"
    vm3.vm.network "private_network", ip: "192.168.56.103"
    vm3.vm.network "public_network"
    
    vm3.vm.provider "virtualbox" do |vb|
      vb.name = "Omni-VM3"
      vb.memory = "1024"
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--groups", "/Main-VMs"]
    end
    
    vm3.vm.provision "shell", inline: <<-SHELL
      apt-get update -qq
      systemctl enable ssh
      systemctl start ssh
      
      # Add other VMs to hosts file
      echo "192.168.56.101 vm1" >> /etc/hosts
      echo "192.168.56.102 vm2" >> /etc/hosts
      
      # Generate SSH key if not exists
      if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
        sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
      fi
      
      # Ensure authorized_keys exists with correct permissions
      sudo -u vagrant touch /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
      
      # Configure SSH client
      sudo -u vagrant cat > /home/vagrant/.ssh/config <<EOF
Host 192.168.56.* vm1 vm2 vm3
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOF
      chmod 600 /home/vagrant/.ssh/config
      chown vagrant:vagrant /home/vagrant/.ssh/config
      
      echo "✅ VM3 provisioned successfully!"
    SHELL
  end
end

# ---------------------------------------------------------------------------------------------------------
# Instructions:
# ---------------------------------------------------------------------------------------------------------
    # Save this file as Vagrantfile in your working directory.
    # To bring up the VMs, run:
    # vagrant up
    # To access a VM, run:
    # vagrant ssh vm1
    # vagrant ssh vm2
    # vagrant ssh vm3
    # To destroy the VMs, run:
    # vagrant destroy -f

    # Note: Ensure VirtualBox and Vagrant are installed on your host machine.
    # After VMs are up, test SSH:
    # vagrant ssh vm1
    # ssh vm2
    # ssh vm3

    # vagrant ssh vm1

    # # Inside vm1:
    # ssh vagrant@vm2  # Should work without password
    # ssh vagrant@vm3  # Should work without password

# ---------------------------------------------------------------------------------------------------------
# SCRIPT TO DISTRIBUTE SSH KEYS
# ---------------------------------------------------------------------------------------------------------

# # The SSH keys weren't distributed. We need to run a script from the host machine to distribute the keys.
#     # Save the following script as setup-ssh.sh in the same directory as your Vagrantfile.
#     # Make it executable: chmod +x setup-ssh.sh 
#     # Run the script to set up SSH key-based authentication between three Vagrant VMs: vm1, vm2, and vm3.

# ```bash
# #!/bin/bash
# # This script sets up SSH key-based authentication between three Vagrant VMs: vm1, vm2, and vm3.
# # It retrieves the public SSH keys from each VM and distributes them to the others' authorized_keys files.
# # Finally, it tests the SSH connections to ensure everything is set up correctly.

# # Usage: Run this script from the directory containing your Vagrantfile.

# echo "==================================================="
# echo "SSH Key Distribution Script for Vagrant VMs"
# echo "==================================================="
# echo ""

# # Step 1: Verify all VMs are running
# echo "Step 1: Verifying VMs are running..."
# vagrant status | grep -E "(vm1|vm2|vm3)" | grep "running" > /dev/null
# if [ $? -ne 0 ]; then
#     echo "ERROR: Not all VMs are running. Please run 'vagrant up' first."
#     exit 1
# fi
# echo "✓ All VMs are running"
# echo ""

# # Step 2: Get public keys from each VM
# echo "Step 2: Retrieving public keys from each VM..."
# VM1_KEY=$(vagrant ssh vm1 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')
# VM2_KEY=$(vagrant ssh vm2 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')
# VM3_KEY=$(vagrant ssh vm3 -c 'cat ~/.ssh/id_rsa.pub 2>/dev/null' 2>/dev/null | sed 's/\r$//')

# if [ -z "$VM1_KEY" ] || [ -z "$VM2_KEY" ] || [ -z "$VM3_KEY" ]; then
#     echo "ERROR: Could not retrieve SSH keys from one or more VMs"
#     echo "VM1 key present: $([ -n "$VM1_KEY" ] && echo 'Yes' || echo 'No')"
#     echo "VM2 key present: $([ -n "$VM2_KEY" ] && echo 'Yes' || echo 'No')"
#     echo "VM3 key present: $([ -n "$VM3_KEY" ] && echo 'Yes' || echo 'No')"
#     exit 1
# fi
# echo "✓ Retrieved all public keys"
# echo ""

# # Step 3: Distribute keys
# echo "Step 3: Distributing SSH keys..."

# # Add keys to VM1
# echo "  Adding keys to VM1..."
# vagrant ssh vm1 -c "echo '$VM2_KEY' >> ~/.ssh/authorized_keys && echo '$VM3_KEY' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
# echo "  ✓ VM1 authorized keys updated"

# # Add keys to VM2
# echo "  Adding keys to VM2..."
# vagrant ssh vm2 -c "echo '$VM1_KEY' >> ~/.ssh/authorized_keys && echo '$VM3_KEY' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
# echo "  ✓ VM2 authorized keys updated"

# # Add keys to VM3
# echo "  Adding keys to VM3..."
# vagrant ssh vm3 -c "echo '$VM1_KEY' >> ~/.ssh/authorized_keys && echo '$VM2_KEY' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
# echo "  ✓ VM3 authorized keys updated"

# echo ""
# echo "Step 4: Testing SSH connections..."
# echo ""

# # Test all connections
# test_connection() {
#     local from=$1
#     local to=$2
#     local result=$(vagrant ssh $from -c "ssh -o BatchMode=yes -o ConnectTimeout=5 vagrant@$to 'echo SUCCESS' 2>/dev/null" 2>/dev/null | grep SUCCESS)
    
#     if [ -n "$result" ]; then
#         echo "  ✓ $from -> $to: Connected"
#         return 0
#     else
#         echo "  ✗ $from -> $to: Failed"
#         return 1
#     fi
# }

# test_connection "vm1" "vm2"
# test_connection "vm1" "vm3"
# test_connection "vm2" "vm1"
# test_connection "vm2" "vm3"
# test_connection "vm3" "vm1"
# test_connection "vm3" "vm2"

# echo ""
# echo "==================================================="
# echo "Setup Complete!"
# echo "==================================================="
# echo ""
# echo "You can now SSH between VMs:"
# echo "  vagrant ssh vm1"
# echo "  Then inside vm1: ssh vagrant@vm2"
# echo ""
# ```