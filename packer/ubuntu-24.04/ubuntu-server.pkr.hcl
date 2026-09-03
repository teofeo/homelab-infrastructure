locals {
  user_data = templatefile(
    "${path.root}/http/user-data.pkrtpl.hcl",
    {
      ssh_username      = var.ssh_username
      ssh_public_key    = var.ssh_public_key
      ssh_password_hash = var.ssh_password_hash
      timezone          = var.timezone
    }
  )

  meta_data = file("${path.root}/http/meta-data")
}

source "proxmox-iso" "ubuntu-server" {

  # ---------------------------------------------------------------------------
  # Proxmox
  # ---------------------------------------------------------------------------

  proxmox_url = var.proxmox_url
  username    = var.proxmox_username
  token       = var.proxmox_token

  insecure_skip_tls_verify = false

  node = var.proxmox_node

  # ---------------------------------------------------------------------------
  # VM
  # ---------------------------------------------------------------------------

  vm_id   = var.vm_id
  vm_name = var.vm_name

  template_name = var.template_name

  template_description = "Ubuntu Server 24.04 LTS Golden Image"

  tags = "template;ubuntu;golden-image;packer"

  # ---------------------------------------------------------------------------
  # Hardware
  # ---------------------------------------------------------------------------

  cores  = 2
  memory = 4096

  cpu_type = "host"

  bios = "seabios"
  os   = "l26"

  qemu_agent = true

  scsi_controller = "virtio-scsi-single"

  # ---------------------------------------------------------------------------
  # Disk
  # ---------------------------------------------------------------------------

  disks {
    type         = "scsi"
    disk_size    = "32G"
    storage_pool = var.proxmox_storage
    format       = "raw"

    io_thread = true
    discard   = true
    ssd       = true
  }

  # ---------------------------------------------------------------------------
  # Network
  # ---------------------------------------------------------------------------

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  # ---------------------------------------------------------------------------
  # Ubuntu ISO
  # ---------------------------------------------------------------------------

  boot_iso {
    type  = "ide"
    index = 2

    iso_file = "${var.proxmox_iso_storage}:iso/${var.ubuntu_iso}"

    iso_checksum = var.ubuntu_iso_checksum

    unmount = true
  }

  # ---------------------------------------------------------------------------
  # NoCloud ISO
  # ---------------------------------------------------------------------------
  #
  # Ce CD contient :
  #
  #   user-data
  #   meta-data
  #
  # Ubuntu le détectera grâce au label "cidata".
  #

  additional_iso_files {
    type              = "ide"
    index             = 1
    iso_storage_pool  = var.proxmox_iso_storage
    unmount           = true
    keep_cdrom_device = false

    cd_content = {
      "user-data" = local.user_data
      "meta-data" = local.meta_data
    }

    cd_label = "cidata"
  }

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  # ide2 = Ubuntu ISO
  # ide1 = cidata
  # scsi0 = disque vide puis disque Ubuntu installé

  boot = "order=scsi0;ide2;net0"

  boot_wait = "10s"

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall quiet ds=nocloud",
    "<f10><wait>",
    "<wait1m>",
    "yes<enter>"
  ]

  # ---------------------------------------------------------------------------
  # SSH
  # ---------------------------------------------------------------------------

  communicator = "ssh"

  ssh_username = var.ssh_username

  ssh_private_key_file = var.ssh_private_key_file

  ssh_timeout = "30m"

  # ---------------------------------------------------------------------------
  # Cloud-Init
  # ---------------------------------------------------------------------------

  cloud_init              = true
  cloud_init_storage_pool = var.proxmox_storage
  cloud_init_disk_type    = "scsi"
}

build {
  name = "ubuntu-server"

  sources = [
    "source.proxmox-iso.ubuntu-server"
  ]

  # ---------------------------------------------------------------------------
  # Wait for cloud-init
  # ---------------------------------------------------------------------------

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "cloud-init status --wait"
    ]
  }

  # ---------------------------------------------------------------------------
  # Golden image cleanup
  # ---------------------------------------------------------------------------

  provisioner "shell" {
    inline = [
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
      "sudo cloud-init clean --logs",
      "sudo rm -rf /var/lib/cloud/instances/*",
      "sudo rm -f /etc/machine-id",
      "sudo touch /etc/machine-id",
      "sudo rm -f /etc/ssh/ssh_host_*",
      "sudo sync"
    ]
  }
}
