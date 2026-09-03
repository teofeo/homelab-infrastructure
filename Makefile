PACKER_DIR := packer/ubuntu-server

.PHONY: init validate fmt build clean

init:
	cd $(PACKER_DIR) && packer init .

validate:
	cd $(PACKER_DIR) && packer validate -var-file=ubuntu-server.auto.pkrvars.hcl .

fmt:
	packer fmt -recursive .

build:
	cd $(PACKER_DIR) && packer build -var-file=ubuntu-server.auto.pkrvars.hcl .

clean:
	rm -rf $(PACKER_DIR)/.packer