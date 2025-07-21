# Homelab Infrastructure

An Ansible-based automation project for managing a Raspberry Pi cluster homelab environment with monitoring, storage, and home automation services.

## 🏗️ Architecture

This homelab consists of a 3-node Raspberry Pi cluster with the following configuration:

- **pi-alpha.lan**: Storage node (Samba file server)
- **pi-beta.lan**: Monitoring node (Prometheus)
- **pi-gamma.lan**: Services node (Home Assistant)

## 🚀 Services

### Core Infrastructure
- **Base Configuration**: System updates, Docker installation, and mDNS setup
- **Storage**: Samba file server with local and shared mount management
- **Monitoring**: Prometheus with Node Exporter for cluster monitoring

### Applications
- **Home Assistant**: Home automation platform
- **Transmission**: BitTorrent client (configured but not deployed by default)

## 📋 Prerequisites

- Python 3.x with pip
- Ansible installed (`pip install -r src/requirements.txt`)
- SSH access to all Raspberry Pi nodes
- Nodes configured with SSH key authentication

## 🔧 Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd homelab
   ```

2. **Install dependencies**:
   ```bash
   pip install -r src/requirements.txt
   ```

3. **Configure your environment**:
   - Update `src/hosts.yml` with your node IP addresses and usernames
   - Modify `src/group_vars/all.yml` for your specific configuration
   - Review and customize role configurations in `src/roles/*/defaults/`

## 🚀 Deployment

### Full Cluster Deployment
```bash
cd src
ansible-playbook homelab.yml
```

### Targeted Deployments

Deploy specific services using tags:

```bash
# Base system configuration
ansible-playbook homelab.yml --tags base

# Storage services
ansible-playbook homelab.yml --tags storage

# Monitoring stack
ansible-playbook homelab.yml --tags monitoring

# Home automation services
ansible-playbook homelab.yml --tags services
```

### Individual Role Deployment
```bash
# Deploy only Prometheus
ansible-playbook homelab.yml --tags monitoring --limit monitoring

# Deploy only Samba
ansible-playbook homelab.yml --tags samba --limit storage
```

## 📁 Project Structure

```
homelab/
├── src/                          # Ansible configuration
│   ├── ansible.cfg              # Ansible configuration
│   ├── homelab.yml              # Main playbook
│   ├── hosts.yml                # Inventory file
│   ├── requirements.txt         # Python dependencies
│   ├── group_vars/              # Global variables
│   │   └── all.yml
│   └── roles/                   # Ansible roles
│       ├── base/                # Base system configuration
│       ├── homeassistant/       # Home Assistant deployment
│       ├── mounts_local/        # Local storage mounts
│       ├── mounts_shared/       # Shared storage mounts
│       ├── prometheus/          # Prometheus monitoring
│       ├── prometheus_node_exporter/  # Node metrics collection
│       ├── samba/               # Samba file server
│       └── transmission/        # BitTorrent client
└── stl/                         # 3D printing files
    ├── knobs/                   # Metric knobs for hardware
    └── raspberry_pi_case/       # Custom Pi case design
```

## 🔧 Configuration

### Default Settings
- **Homelab root directory**: `/opt/homelab`
- **Local storage mount**: `/mnt/homelab/local`
- **Shared storage mount**: `/mnt/homelab/shared`
- **Service user**: `homelab`

### Customization
Edit `src/group_vars/all.yml` to modify:
- Directory paths
- User credentials
- Service configurations

## 📊 Monitoring

Prometheus is deployed on `pi-beta.lan` and collects metrics from all cluster nodes via Node Exporter. Access the Prometheus web interface at:
- `http://pi-beta.lan:9090`

## 🗄️ Storage

Samba file server runs on `pi-alpha.lan` providing:
- Local storage for node-specific data
- Shared storage accessible across the cluster
- Centralized file management

## 🏠 3D Printing Files

The `stl/` directory contains 3D printing files for:
- **Metric knobs**: Hardware control knobs (M5-M12)
- **Raspberry Pi case**: Custom cluster case design

## 🔍 Troubleshooting

### Common Issues

1. **SSH Connection Failures**:
   - Verify SSH key authentication is set up
   - Check node IP addresses in `hosts.yml`
   - Ensure SSH service is running on target nodes

2. **Docker Installation Issues**:
   - Ensure sufficient disk space on target nodes
   - Check internet connectivity for package downloads

3. **Service Deployment Failures**:
   - Review Ansible output for specific error messages
   - Verify required ports are not in use
   - Check disk space and system resources

### Debugging
Run playbooks with increased verbosity:
```bash
ansible-playbook homelab.yml -vvv
```

## 📝 Contributing

1. Test changes in a development environment
2. Update documentation for new features
3. Follow Ansible best practices
4. Ensure idempotent playbook execution

## 📄 License

This project is provided as-is for educational and personal use.

## 🔗 References

- [Ansible Documentation](https://docs.ansible.com/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
