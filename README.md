# Homelab Infrastructure as Code

Ce dépôt centralise l'automatisation complète de mon homelab. L'objectif est de maintenir une infrastructure reproductible, sécurisée et documentée en utilisant les standards de l'industrie (IaC).

## 🚀 Architecture
- **Hyperviseur**: Proxmox VE
- **Provisioning**: Terraform (Gestion des VMs, LXC, réseaux)
- **Configuration**: Ansible (Hardening, services, déploiements Docker)
- **CI/CD**: GitHub Actions (Validation, linting)

## 📁 Structure du Projet
```bash
.
├── ansible/          # Playbooks et rôles Ansible
├── terraform/        # Modules Terraform par environnement
├── .github/          # Workflows CI/CD
└── README.md
