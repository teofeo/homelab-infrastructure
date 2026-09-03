# Homelab Infrastructure

Infrastructure as Code for the homelab.

## Structure

```text
homelab-infrastructure/
├── Makefile
├── packer/
│   └── ubuntu-server/
│       ├── ubuntu-server.pkr.hcl
│       ├── variables.pkr.hcl
│       ├── versions.pkr.hcl
│       ├── ubuntu-server.auto.pkrvars.example.hcl
│       └── http/
│           ├── meta-data
│           └── user-data.pkrtpl.hcl
└── ...