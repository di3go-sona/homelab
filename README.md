# Homelab Infrastructure

An Ansible + GitOps automation project for managing a Raspberry Pi Kubernetes cluster, using k0s, ArgoCD, and Cilium.

## 🏗️ Architecture

3-node Raspberry Pi cluster, all running as Kubernetes controller+worker nodes:

| Node | IP | Role |
|---|---|---|
| `pi-delta.lan` | 192.168.8.13 | controller+worker, NFS storage |
| `pi-epsilon.lan` | 192.168.8.14 | controller+worker |
| `pi-gamma.lan` | 192.168.8.15 | controller+worker, k8s API endpoint |

**Kubernetes**: [k0s](https://k0sproject.io/) v1.35.1  
**GitOps**: ArgoCD — all apps managed declaratively from this repo  
**Networking**: Cilium CNI with L2 load balancing (IP pool: `192.168.8.20–29`)  
**Storage**: NFS-CSI driver backed by a drive mounted on `pi-delta` at `/mnt/hdd0`  
**Ingress domain**: `*.patat.in`

## 🚀 Applications

All apps are deployed via ArgoCD and live in `src/argo/apps/`.

| App | Ingress | Notes |
|---|---|---|
| **ArgoCD** | `argo.patat.in` | GitOps controller, anonymous admin access |
| **Transmission** | `transmission.patat.in` | BitTorrent client |
| **Jellyfin** | `jellyfin.patat.in` | Media server |
| **Sonarr** | `sonarr.patat.in` | TV show management |
| **Radarr** | `radarr.patat.in` | Movie management |
| **Prowlarr** | `prowlarr.patat.in` | Indexer manager |
| **FlareSolverr** | — | Cloudflare bypass proxy |
| **Home Assistant** | `homeassistant.patat.in` | Home automation, multus macvlan @ 192.168.8.80 for mDNS |
| **ESPHome** | `esphome.patat.in` | ESP8266/ESP32 firmware builder |

All media apps share a 10Ti NFS-backed PVC mounted at `/data`.

## 📋 Prerequisites

- Python 3.x and `ansible` (`pip install -r src/ansible/requirements.txt`)
- [`k0sctl`](https://github.com/k0sproject/k0sctl) installed locally
- SSH key access to all nodes (as `root`)
- `kubectl` configured (kubeconfig written to `~/.kube/config.homelab`)

## 🔧 Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/di3go-sona/homelab.git
   cd homelab
   ```

2. **Install dependencies**:
   ```bash
   pip install -r src/ansible/requirements.txt
   ```

3. **Configure your environment**:
   - Update `src/ansible/inventory/hosts.yml` with your node IPs
   - Edit `src/ansible/group_vars/all.yml` for storage mounts and kubeconfig path

## 🚀 Deployment

All commands run from `src/ansible/`.

### Full cluster bootstrap
```bash
cd src/ansible
ansible-playbook homelab.yml
```

This runs in order: base OS setup → storage mounts → k0s cluster → Cilium + ArgoCD bootstrap.

### Targeted deployments

```bash
# Base OS config (packages, cgroups, NTP)
ansible-playbook homelab.yml --tags base

# Storage mounts and NFS exports
ansible-playbook homelab.yml --tags mounts

# Provision / update k0s Kubernetes cluster
ansible-playbook homelab.yml --tags k0s

# Install Cilium + ArgoCD and apply root app
ansible-playbook homelab.yml --tags helm
```

## 📁 Project Structure

```
homelab/
├── src/
│   ├── ansible/                     # Ansible automation
│   │   ├── ansible.cfg
│   │   ├── homelab.yml              # Main playbook
│   │   ├── inventory/
│   │   │   └── hosts.yml            # Node inventory
│   │   ├── group_vars/
│   │   │   └── all.yml              # Global variables (mounts, kubeconfig)
│   │   └── roles/
│   │       ├── base/                # OS setup: packages, cgroups, NTP
│   │       ├── mounts/              # Disk mounts + NFS exports
│   │       ├── k0s/                 # k0s cluster provisioning via k0sctl
│   │       └── helm/                # Cilium + ArgoCD Helm installs
│   └── argo/                        # ArgoCD GitOps definitions
│       ├── root.yaml                # Root Application (bootstraps all apps)
│       └── apps/
│           ├── argocd/              # ArgoCD self-management
│           ├── cilium/              # CNI + L2 load balancer
│           ├── nfs-csi/             # NFS storage class
│           ├── homeassistant/        # Home Assistant (multus macvlan for mDNS)
│           ├── esphome/              # ESPHome firmware builder
│           └── media/               # Media stack (Jellyfin, *arr, etc.)
└── stl/                             # 3D printing files
    ├── knobs/                       # Metric knobs M5–M12
    └── raspberry_pi_case/           # 14-unit Pi cluster case
```

## 🗄️ Storage

`pi-delta.lan` exports `/mnt/hdd0` over NFS. The `nfs-csi` storage class provisions PVCs from `/mnt/hdd0/homelab`. The media stack uses a single 10Ti PVC shared across all apps.

## 🏠 3D Printing Files

The `stl/` directory has printable files for the physical build:
- **Knobs**: M5–M12 metric screw knobs ([MakerWorld](https://makerworld.com/en/models/748617-knob-for-metric-screw-m5-to-m12))
- **Pi case**: 14-slot cluster rack case ([Thingiverse](https://www.thingiverse.com/thing:4756812))

## 🔍 Troubleshooting

### SSH / Ansible

- Verify SSH key access: `ssh root@pi-delta.lan`
- Check inventory IPs in `src/ansible/inventory/hosts.yml`
- Run with verbose output: `ansible-playbook homelab.yml -vvv`

### Kubernetes

- Set kubeconfig: `export KUBECONFIG=~/.kube/config.homelab`
- Check node status: `kubectl get nodes`
- Check ArgoCD apps: `kubectl get applications -n argocd`

### k0sctl

- Recreate the cluster (destructive): `ansible-playbook homelab.yml --tags k0s -e k0s_recreate=true`

## 📄 License

This project is provided as-is for educational and personal use.

## 🔗 References

- [k0s Documentation](https://docs.k0sproject.io/)
- [k0sctl](https://github.com/k0sproject/k0sctl)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Cilium Documentation](https://docs.cilium.io/)
- [NFS CSI Driver](https://github.com/kubernetes-csi/csi-driver-nfs)
