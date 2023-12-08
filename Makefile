CURRENT_DIR:=$(shell pwd)
SHELL:=/bin/bash

provision:	
	flux bootstrap git \
	--url=ssh://git@github.com/1ndistinct/fluxcd.git \
	--branch=dev \
	--path=clusters/home \
	--private-key-file=/${HOME}/.ssh/id_ed25519

apply-argo-repo-creds:
	kubectl apply -f repo-creds.yaml
