CURRENT_DIR:=$(shell pwd)
SHELL:=/bin/bash

.PHONY provision:


provision:	
	flux bootstrap git \
	--url=ssh://git@github.com/Wednesday-Vibes/fluxcd.git \
	--branch=dev \
	--path=clusters/kind-kind \
	--private-key-file=/root/.ssh/id_ed25519

