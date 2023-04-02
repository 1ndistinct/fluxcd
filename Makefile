CURRENT_DIR:=$(shell pwd)
SHELL:=/bin/bash

.PHONY provision apply-argo-repo-creds argo-creds:


provision:	
	flux bootstrap git \
	--url=ssh://git@github.com/Wednesday-Vibes/fluxcd.git \
	--branch=dev \
	--path=clusters/kind-kind \
	--private-key-file=/root/.ssh/id_ed25519

apply-argo-repo-creds:
	kubectl apply -f repo-creds.yaml
