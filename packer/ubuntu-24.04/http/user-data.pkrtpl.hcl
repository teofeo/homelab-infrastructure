#cloud-config

autoinstall:
  version: 1

  locale: en_US.UTF-8

  keyboard:
    layout: us
    variant: ""

  timezone: ${timezone}

  identity:
    hostname: ubuntu-template
    username: ${ssh_username}
    password: "${ssh_password_hash}"
    
  ssh:
    install-server: true
    authorized-keys:
      - "${ssh_public_key}"
    allow-pw: false

  storage:
    layout:
      name: direct

  packages:
    - qemu-guest-agent
    - curl
    - wget
    - vim
    - git
    - ca-certificates
    - htop

  updates: all

  late-commands:
    - curtin in-target -- sh -c 'echo "${ssh_username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${ssh_username}'
    - curtin in-target -- chmod 440 /etc/sudoers.d/${ssh_username}
    - curtin in-target -- systemctl enable qemu-guest-agent
    - for dev in /dev/sr*; do eject "$dev" || true; done

  shutdown: reboot