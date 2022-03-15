AWS_REGION=us-east-1
AMI_ARCH=amd64-server
AMI_PREFIX=semaphore-agent
AGENT_VERSION=v2.0.19
VERSION=$(shell cat package.json | jq -r '.version')
HASH=$(shell find Makefile packer/ -type f -exec md5sum "{}" + | awk '{print $$1}' | sort | md5sum | awk '{print $$1}')

venv.execute:
	python3 -m venv venv && \
	. venv/bin/activate && \
	pip install --upgrade pip && \
	pip install -r requirements.txt && \
	$(COMMAND) && \
	deactivate && \
	cd -

packer.fmt:
	cd packer && packer fmt . && cd -

packer.validate:
	$(MAKE) venv.execute COMMAND='\
		cd packer && \
		packer validate \
			-var "stack_version=v$(VERSION)" \
			-var "agent_version=$(AGENT_VERSION)" \
			-var "hash=$(HASH)" \
			-var "region=$(AWS_REGION)" \
			-var "ami_prefix=$(AMI_PREFIX)" \
			-var "arch=$(AMI_ARCH)" \
			.'

packer.init:
	$(MAKE) venv.execute COMMAND='cd packer && packer init .'

packer.build:
	$(MAKE) venv.execute COMMAND='\
		cd packer && \
		packer build \
			-var "stack_version=v$(VERSION)" \
			-var "agent_version=$(AGENT_VERSION)" \
			-var "hash=$(HASH)" \
			-var "region=$(AWS_REGION)" \
			-var "ami_prefix=$(AMI_PREFIX)" \
			-var "arch=$(AMI_ARCH)" \
			ubuntu-focal.pkr.hcl'

ansible.lint:
	$(MAKE) venv.execute COMMAND='cd packer && ansible-lint'
