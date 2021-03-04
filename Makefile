PIP2 := $(shell command -v pip2 2> /dev/null)
JINJA2_PACKAGE := $(shell command pip2 list | grep -F Jinja2)
ENCRYPTED_FILES := group_vars/all/vault_system.yml

all:

server: jinja2
	ansible-playbook --ask-become-pass --ask-vault-pass server.yml

jinja2: pip2_install
ifndef JINJA2_PACKAGE
	echo $(JINJA2_PACKAGE)
	pip2 install --user --upgrade jinja2
endif

pip2_install:
ifndef PIP2
	sudo yum install python2-pip
endif

encrypt: $(ENCRYPTED_FILES)
	ansible-vault encrypt $(ENCRYPTED_FILES)

.PHONY: server jinja2 pip2_install encrypt all
