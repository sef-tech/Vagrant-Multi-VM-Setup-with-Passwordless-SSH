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
