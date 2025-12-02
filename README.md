# Vagrant-Multi-VM-Setup-with-Passwordless-SSH

A complete Vagrant configuration for creating three interconnected Ubuntu VMs with passwordless SSH authentication between them.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [VM Configuration](#vm-configuration)
- [Network Configuration](#network-configuration)
- [SSH Configuration](#ssh-configuration)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)
- [Common Commands](#common-commands)
- [Contributing](#contributing)

## 🎯 Overview

This project provides a ready-to-use Vagrant configuration that creates three Ubuntu 24.04 VMs with the following features:

- **Passwordless SSH** between all VMs
- **Private network** for inter-VM communication
- **Public network** access for internet connectivity
- **Automatic host resolution** via `/etc/hosts`
- **SSH key distribution** automation
- **No host verification prompts** for seamless connectivity

## 📦 Prerequisites

Before you begin, ensure you have the following installed on your host machine:

- **VirtualBox** (6.1 or later)
  - Download: https://www.virtualbox.org/wiki/Downloads
- **Vagrant** (2.2 or later)
  - Download: https://www.vagrantup.com/downloads
- **Git** (optional, for cloning the repository)

### System Requirements

- **RAM**: At least 4GB free (VMs use 1GB each)
- **Disk Space**: At least 10GB free
- **OS**: Windows, macOS, or Linux

## 🏗️ Architecture

### Network Topology

```
┌─────────────────────────────────────────────────────┐
│                    Host Machine                     │
│                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │    VM1      │  │    VM2      │  │    VM3      │  │
│  │  (omni-1)   │  │  (omni-2)   │  │  (omni-3)   │  │
│  │             │  │             │  │             │  │
│  │ 192.168.    │  │ 192.168.    │  │ 192.168.    │  │
│  │  56.101     │  │  56.102     │  │  56.103     │  │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │
│         │                │                │         │
│         └────────────────┴────────────────┘         │
│              Private Network (192.168.56.0/24)      │
│                                                     │
└─────────────────────────────────────────────────────┘
                           │
                           ▼
                      Internet
```

### VM Specifications

| VM Name | Hostname | Private IP | Memory | CPUs | VirtualBox Name |
|---------|----------|------------|--------|------|-----------------|
| vm1     | omni-1   | 192.168.56.101 | 1024 MB | 1 | Omni-VM1 |
| vm2     | omni-2   | 192.168.56.102 | 1024 MB | 1 | Omni-VM2 |
| vm3     | omni-3   | 192.168.56.103 | 1024 MB | 1 | Omni-VM3 |

## 🚀 Quick Start

### 1. Clone or Download

```bash
# Clone the repository (if using Git)
git clone <repository-url>
cd <repository-directory>

# Or download and extract the files
```

### 2. Start the VMs

```bash
vagrant up
```

This command will:
- Download the Ubuntu 24.04 base box (first time only)
- Create and configure all three VMs
- Set up networking and SSH configurations
- Generate SSH keys on each VM

### 3. Distribute SSH Keys

```bash
chmod +x setup-ssh.sh
./setup-ssh.sh
```

This script will:
- Verify all VMs are running
- Retrieve public SSH keys from each VM
- Distribute keys to all VMs' `authorized_keys`
- Test SSH connectivity between all VMs

### 4. Access VMs

```bash
# SSH into VM1
vagrant ssh vm1

# From inside VM1, connect to VM2 (no password required)
ssh vm2

# Or use the full command
ssh vagrant@vm2
```

## 🔧 Detailed Setup

### Step-by-Step Installation

#### 1. Install VirtualBox

**Windows:**
```powershell
# Download installer from https://www.virtualbox.org/wiki/Downloads
# Run the installer with administrator privileges
```

**macOS:**
```bash
# Using Homebrew
brew install --cask virtualbox
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install virtualbox
```

#### 2. Install Vagrant

**Windows:**
```powershell
# Download installer from https://www.vagrantup.com/downloads
# Run the installer
```

**macOS:**
```bash
# Using Homebrew
brew install vagrant
```

**Linux (Ubuntu/Debian):**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

#### 3. Verify Installation

```bash
# Check VirtualBox
VBoxManage --version

# Check Vagrant
vagrant --version
```

#### 4. Create Project Directory

```bash
mkdir vagrant-multi-vm
cd vagrant-multi-vm
```

#### 5. Add Configuration Files

Place the `Vagrantfile` and `setup-ssh.sh` in the project directory.

#### 6. Initialize and Start

```bash
# Start all VMs
vagrant up

# Run SSH setup
./setup-ssh.sh
```

## ⚙️ VM Configuration

### Vagrantfile Structure

The `Vagrantfile` defines three identical VMs with slight variations:

```ruby
config.vm.define "vm1" do |vm1|
  # Hostname configuration
  vm1.vm.hostname = "omni-1"
  
  # Network configuration
  vm1.vm.network "private_network", ip: "192.168.56.101"
  vm1.vm.network "public_network"
  
  # Provider (VirtualBox) settings
  vm1.vm.provider "virtualbox" do |vb|
    vb.name = "Omni-VM1"
    vb.memory = "1024"
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--groups", "/Main-VMs"]
  end
  
  # Provisioning script
  vm1.vm.provision "shell", inline: <<-SHELL
    # Update packages
    # Configure SSH
    # Set up hosts file
    # Generate SSH keys
  SHELL
end
```

### Customization Options

#### Change VM Resources

Edit the provider section in `Vagrantfile`:

```ruby
vm1.vm.provider "virtualbox" do |vb|
  vb.memory = "2048"            # Change from 1024 to 2048 MB
  vb.cpus = 2                   # Change from 1 to 2 CPUs
end
```

#### Change IP Addresses

Edit the network configuration:

```ruby
vm1.vm.network "private_network", ip: "192.168.56.201"  # New IP
```

**Note:** Also update the `/etc/hosts` entries in the provisioning script.

#### Change Base Box

Edit the base box:

```ruby
config.vm.box = "ubuntu/jammy64"       # Use Ubuntu 22.04 instead
```

## 🌐 Network Configuration

### Private Network (Host-Only)

- **Network**: 192.168.56.0/24
- **Purpose**: Inter-VM communication
- **Connectivity**: VMs can communicate with each other and the host

### Public Network (Bridged)

- **Purpose**: Internet access
- **Configuration**: DHCP (automatic)
- **Connectivity**: VMs get IP addresses from your local network

### Hosts File Configuration

Each VM automatically configures `/etc/hosts` for name resolution:

```bash
# On VM1
192.168.56.102 vm2
192.168.56.103 vm3

# On VM2
192.168.56.101 vm1
192.168.56.103 vm3

# On VM3
192.168.56.101 vm1
192.168.56.102 vm2
```

This allows you to use hostnames instead of IP addresses:

```bash
ssh vm2  # Instead of ssh 192.168.56.102
```

## 🔐 SSH Configuration

### SSH Key Generation

Each VM automatically generates an RSA 2048-bit SSH key pair during provisioning:

- **Private key**: `/home/vagrant/.ssh/id_rsa`
- **Public key**: `/home/vagrant/.ssh/id_rsa.pub`

### SSH Client Configuration

The VMs are configured with the following SSH client settings (`.ssh/config`):

```
Host 192.168.56.* vm1 vm2 vm3
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
```

This configuration:
- Disables host key verification prompts
- Prevents storing host keys
- Applies to all VMs in the network

### Authorized Keys

The `setup-ssh.sh` script distributes public keys to all VMs' `authorized_keys` files:

```
VM1's authorized_keys: Contains VM2 and VM3 public keys
VM2's authorized_keys: Contains VM1 and VM3 public keys
VM3's authorized_keys: Contains VM1 and VM2 public keys
```

## 💡 Usage Examples

### Basic SSH Access

```bash
# From host machine, access VM1
vagrant ssh vm1

# From VM1, access VM2 (passwordless)
ssh vm2

# From VM1, access VM3 using full syntax
ssh vagrant@vm3

# From VM2, access VM1
ssh vagrant@192.168.56.101
```

### Running Commands Remotely

```bash
# From VM1, run a command on VM2
ssh vm2 'hostname'

# From VM1, run multiple commands on VM3
ssh vm3 'echo "Hello from VM3" && uname -a'

# From host, run command on VM1, which then runs command on VM2
vagrant ssh vm1 -c 'ssh vm2 "df -h"'
```

### Copying Files Between VMs

```bash
# From VM1, copy file to VM2
scp /home/vagrant/myfile.txt vm2:/home/vagrant/

# From VM1, copy directory to VM3
scp -r /home/vagrant/mydir vm3:/home/vagrant/

# From VM2, copy file from VM1
scp vm1:/home/vagrant/file.txt .
```

### Advanced SSH Usage

```bash
# SSH with port forwarding
ssh -L 8080:localhost:80 vm2

# SSH with background process
ssh -f vm3 'nohup ./long_running_script.sh &'

# SSH with pseudo-terminal
ssh -t vm2 'sudo apt update'
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### Issue 1: VMs Won't Start

**Symptoms:**
```
There was an error while executing `VBoxManage`...
```

**Solutions:**
```bash
# Check VirtualBox is properly installed
VBoxManage --version

# Restart VirtualBox service (Linux)
sudo systemctl restart vboxdrv

# On Windows/Mac, restart VirtualBox application

# Check for conflicting VMs
VBoxManage list vms

# Remove stale VMs if needed
vagrant destroy -f
```

#### Issue 2: SSH Still Asks for Password

**Symptoms:**
```
vagrant@vm2's password:
```

**Solutions:**
```bash
# Re-run the SSH setup script
./setup-ssh.sh

# Manually verify keys are distributed
vagrant ssh vm1 -c 'cat ~/.ssh/authorized_keys'

# Check SSH key permissions
vagrant ssh vm1 -c 'ls -la ~/.ssh/'

# Permissions should be:
# drwx------ .ssh/
# -rw------- .ssh/authorized_keys
# -rw------- .ssh/id_rsa
# -rw-r--r-- .ssh/id_rsa.pub

# Fix permissions if needed
vagrant ssh vm1 -c 'chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys ~/.ssh/id_rsa'
```

#### Issue 3: Network Not Working

**Symptoms:**
```
Cannot reach VM from another VM
```

**Solutions:**
```bash
# Check VM network interfaces
vagrant ssh vm1 -c 'ip addr show'

# Verify private network is up
vagrant ssh vm1 -c 'ping -c 2 192.168.56.102'

# Check firewall (should be disabled by default)
vagrant ssh vm1 -c 'sudo ufw status'

# Restart networking if needed
vagrant ssh vm1 -c 'sudo systemctl restart networking'
```

#### Issue 4: "vagrant up" Hangs

**Symptoms:**
```
Waiting for machine to boot...
```

**Solutions:**
```bash
# Increase timeout (add to Vagrantfile)
config.vm.boot_timeout = 600

# Or destroy and retry
vagrant destroy -f && vagrant up

# Check VirtualBox GUI for error messages
```

#### Issue 5: SSH Setup Script Fails

**Symptoms:**
```
ERROR: Could not retrieve SSH keys from one or more VMs
```

**Solutions:**
```bash
# Ensure all VMs are running
vagrant status

# Start any stopped VMs
vagrant up vm1 vm2 vm3

# Verify SSH keys exist in each VM
vagrant ssh vm1 -c 'cat ~/.ssh/id_rsa.pub'
vagrant ssh vm2 -c 'cat ~/.ssh/id_rsa.pub'
vagrant ssh vm3 -c 'cat ~/.ssh/id_rsa.pub'

# If keys don't exist, reprovision
vagrant provision vm1
```

### Debugging Commands

```bash
# Check Vagrant status
vagrant status

# Check detailed VM status
vagrant global-status

# View VirtualBox VMs
VBoxManage list vms

# SSH with verbose output
vagrant ssh vm1 -- -vvv ssh vm2

# Check VM logs
vagrant ssh vm1 -c 'sudo journalctl -xe'
```

## 📁 File Structure

```
vagrant-multi-vm/
│
├── Vagrantfile           # Main Vagrant configuration
├── setup-ssh.sh          # SSH key distribution script
├── README.md             # This file
│
└── .vagrant/             # Vagrant metadata (auto-generated)
    ├── machines/         # VM-specific data
    └── rgloader/         # Vagrant internal files
```

### File Descriptions

- **Vagrantfile**: Defines VM configurations, networking, and provisioning
- **setup-ssh.sh**: Automates SSH key exchange between VMs
- **README.md**: Documentation for the project
- **.vagrant/**: Auto-generated directory containing Vagrant's internal state

## 📝 Common Commands

### Vagrant Commands

```bash
# Start all VMs
vagrant up

# Start specific VM
vagrant up vm1

# Stop all VMs
vagrant halt

# Stop specific VM
vagrant halt vm2

# Restart VMs
vagrant reload

# Restart with re-provisioning
vagrant reload --provision

# Destroy all VMs
vagrant destroy

# Destroy without confirmation
vagrant destroy -f

# Check VM status
vagrant status

# Check all Vagrant VMs on system
vagrant global-status

# SSH into VM
vagrant ssh vm1

# Run command on VM from host
vagrant ssh vm1 -c 'command'

# Re-run provisioning
vagrant provision

# Suspend VMs (save state)
vagrant suspend

# Resume suspended VMs
vagrant resume

# Take snapshot
vagrant snapshot save snapshot_name

# Restore snapshot
vagrant snapshot restore snapshot_name

# List snapshots
vagrant snapshot list
```

### SSH Commands (from within VMs)

```bash
# Connect to another VM
ssh vm2
ssh vagrant@vm2
ssh 192.168.56.102

# Run remote command
ssh vm2 'command'

# Copy files
scp file.txt vm2:/path/to/destination
scp vm2:/path/to/file .

# Copy recursively
scp -r directory/ vm2:/path/

# SSH with port forwarding
ssh -L local_port:localhost:remote_port vm2

# Background SSH connection
ssh -f vm2 'command &'
```

### Useful System Commands

```bash
# Check network connectivity
ping vm2
ping 192.168.56.102

# Check open ports
netstat -tulpn

# View network interfaces
ip addr show
ifconfig

# Check SSH service status
sudo systemctl status ssh

# View SSH logs
sudo journalctl -u ssh

# Test SSH connection with debug
ssh -vvv vm2

# Check authorized keys
cat ~/.ssh/authorized_keys

# Check SSH key fingerprint
ssh-keygen -lf ~/.ssh/id_rsa.pub
```

## 🔄 Updating the Environment

### Update Ubuntu Packages

```bash
# On each VM
vagrant ssh vm1 -c 'sudo apt update && sudo apt upgrade -y'
vagrant ssh vm2 -c 'sudo apt update && sudo apt upgrade -y'
vagrant ssh vm3 -c 'sudo apt update && sudo apt upgrade -y'

# Or from inside a VM
sudo apt update && sudo apt upgrade -y
```

### Update Vagrant Box

```bash
# Check for updates
vagrant box outdated

# Update box
vagrant box update

# Recreate VMs with new box
vagrant destroy -f
vagrant up
./setup-ssh.sh
```

## 🛠️ Advanced Configuration

### Adding More VMs

To add a fourth VM, add this to the `Vagrantfile`:

```ruby
config.vm.define "vm4" do |vm4|
  vm4.vm.hostname = "omni-4"
  vm4.vm.network "private_network", ip: "192.168.56.104"
  vm4.vm.network "public_network"
  
  vm4.vm.provider "virtualbox" do |vb|
    vb.name = "Omni-VM4"
    vb.memory = "1024"
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--groups", "/Main-VMs"]
  end
  
  vm4.vm.provision "shell", inline: <<-SHELL
    apt-get update -qq
    systemctl enable ssh
    systemctl start ssh
    
    echo "192.168.56.101 vm1" >> /etc/hosts
    echo "192.168.56.102 vm2" >> /etc/hosts
    echo "192.168.56.103 vm3" >> /etc/hosts
    
    if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
      sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
    fi
    
    sudo -u vagrant touch /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    
    sudo -u vagrant cat > /home/vagrant/.ssh/config <<EOF
Host 192.168.56.* vm1 vm2 vm3 vm4
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOF
    chmod 600 /home/vagrant/.ssh/config
    chown vagrant:vagrant /home/vagrant/.ssh/config
    
    echo "✅ VM4 provisioned successfully!"
  SHELL
end
```

Then update `setup-ssh.sh` to include vm4.

### Installing Additional Software

Add to the provisioning section:

```ruby
vm1.vm.provision "shell", inline: <<-SHELL
  # Existing commands...
  
  # Install additional packages
  apt-get install -y docker.io
  apt-get install -y nginx
  apt-get install -y python3-pip
  
  # Configure services
  systemctl enable docker
  systemctl start docker
SHELL
```

### Synced Folders

Add shared folders between host and VMs:

```ruby
config.vm.define "vm1" do |vm1|
  # Existing configuration...
  
  # Sync folder
  vm1.vm.synced_folder "./shared", "/home/vagrant/shared"
end
```

## 🧪 Testing

### Verify SSH Connectivity

```bash
# Run comprehensive SSH test
for vm in vm1 vm2 vm3; do
  echo "Testing from $vm..."
  vagrant ssh $vm -c 'for target in vm1 vm2 vm3; do ssh -o ConnectTimeout=2 $target "echo Connected to \$(hostname)" || echo "Failed to connect to $target"; done'
done
```

### Network Connectivity Test

```bash
# Ping test from each VM
for vm in vm1 vm2 vm3; do
  echo "Ping test from $vm..."
  vagrant ssh $vm -c 'ping -c 1 vm2 && ping -c 1 vm3'
done
```

### Port Scanning

```bash
# Check open ports on each VM
vagrant ssh vm1 -c 'nc -zv vm2 22'
vagrant ssh vm1 -c 'nc -zv vm3 22'
```

## 📊 Monitoring

### Resource Usage

```bash
# Check memory usage
vagrant ssh vm1 -c 'free -h'

# Check disk usage
vagrant ssh vm1 -c 'df -h'

# Check CPU info
vagrant ssh vm1 -c 'lscpu'

# Check running processes
vagrant ssh vm1 -c 'top -b -n 1 | head -20'
```

### System Information

```bash
# OS version
vagrant ssh vm1 -c 'cat /etc/os-release'

# Kernel version
vagrant ssh vm1 -c 'uname -r'

# Uptime
vagrant ssh vm1 -c 'uptime'

# Network statistics
vagrant ssh vm1 -c 'ss -tuln'
```

## 🔒 Security Considerations

### SSH Key Security

- SSH keys are generated automatically during provisioning
- Private keys remain on their respective VMs
- Only public keys are distributed
- Keys are 2048-bit RSA (secure for most purposes)

### Network Security

- Private network is isolated from external access
- Only accessible from host machine
- No password authentication for SSH (key-based only)
- StrictHostKeyChecking disabled (convenient but less secure)

### Improving Security

For production use, consider:

1. **Enable StrictHostKeyChecking**:
   ```ruby
   Host 192.168.56.* vm1 vm2 vm3
       StrictHostKeyChecking yes
   ```

2. **Use stronger SSH keys**:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
   ```

3. **Enable firewall**:
   ```bash
   sudo ufw enable
   sudo ufw allow from 192.168.56.0/24 to any port 22
   ```

4. **Regular updates**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

## 📚 Additional Resources

### Official Documentation

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [OpenSSH Manual](https://www.openssh.com/manual.html)

### Tutorials

- [Vagrant Getting Started](https://learn.hashicorp.com/vagrant)
- [VirtualBox Networking](https://www.virtualbox.org/manual/ch06.html)
- [SSH Key Management](https://www.ssh.com/academy/ssh/keygen)

### Community

- [Vagrant Forum](https://discuss.hashicorp.com/c/vagrant/)
- [VirtualBox Forums](https://forums.virtualbox.org/)
- [Stack Overflow - Vagrant](https://stackoverflow.com/questions/tagged/vagrant)

## 🤝 Contributing

Contributions are welcome! Here are ways you can contribute:

1. **Report bugs**: Open an issue describing the problem
2. **Suggest features**: Open an issue with your feature request
3. **Submit pull requests**: Fork, make changes, and submit a PR
4. **Improve documentation**: Fix typos, add examples, clarify instructions

### Development Workflow

```bash
# Fork the repository
# Clone your fork
git clone <your-fork-url>

# Create a branch
git checkout -b feature/your-feature

# Make changes
# Test changes
vagrant destroy -f && vagrant up && ./setup-ssh.sh

# Commit changes
git commit -m "Description of changes"

# Push to your fork
git push origin feature/your-feature

# Open a pull request
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- HashiCorp for Vagrant
- Oracle for VirtualBox
- Ubuntu team for the base image
- Community contributors

## 📞 Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search [existing issues](https://github.com/your-repo/issues)
3. Open a [new issue](https://github.com/your-repo/issues/new) with:
   - Your operating system
   - Vagrant version (`vagrant --version`)
   - VirtualBox version (`VBoxManage --version`)
   - Error messages
   - Steps to reproduce

---

**Happy VM-ing! 🚀**
