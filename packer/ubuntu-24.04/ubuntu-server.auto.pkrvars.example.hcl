proxmox_url      = "https://proxmox.example.com:8006/api2/json"
proxmox_username = "packer@pve!packer"
proxmox_token    = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

proxmox_node        = "pve"
proxmox_storage     = "local-lvm"
proxmox_iso_storage = "local"

vm_id         = 9000
vm_name       = "ubuntu-server-24-04"
template_name = "ubuntu-server-24-04"

ubuntu_iso = "ubuntu-24.04.3-live-server-amd64.iso"

# SHA256 du fichier ISO Ubuntu téléchargé.
ubuntu_iso_checksum = "sha256:REPLACE_ME"


ssh_username    = "ubuntu"
ssh_public_key  = "ssh-ed25519 AAAA... user@machine"
ssh_private_key_file = "~/.ssh/id_ed25519"
ssh_password_hash = "$6$8XN6cbFmlYJwpwIt$WxxMD2DxHNTRm9nmnaA2e4s.FeSpuhfllV8kdA6tziOmC6CqsRW/4PozIgMj6zMRFyazMWTQHAXTdJWQGv9UK."
timezone        = "Europe/Paris"