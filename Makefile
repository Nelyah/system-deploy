ANSIBLE := $(shell command -v ansible-playbook 2> /dev/null)
PIP2 := $(shell command -v pip2 2> /dev/null)
JINJA2_PACKAGE := $(shell command pip2 list | grep -F Jinja2)
ENCRYPTED_FILES := group_vars/all/vault_system.yml roles/server/files/cert.pem roles/server/files/key.pem roles/server/files/https-cert.pem roles/server/files/https-key.pem roles/server/vars/vault_syncthing.yml

all:

server: jinja2 ansible
	ansible-playbook --ask-become-pass --ask-vault-pass server.yml

jinja2: pip2_install
ifndef JINJA2_PACKAGE
	pip2 install --user --upgrade jinja2
endif

pip2_install:
ifndef PIP2
	sudo yum install python2-pip
endif

ansible:
ifndef ANSIBLE
	sudo yum install ansible-playbook ansible
endif

encrypt: $(ENCRYPTED_FILES)
	ansible-vault encrypt $(ENCRYPTED_FILES)

.PHONY: server jinja2 pip2_install encrypt all ansible
