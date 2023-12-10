CURRENT_DIR:=$(shell pwd)
SHELL:=/bin/bash

provision:	
	flux bootstrap git \
	--url=ssh://git@github.com/1ndistinct/fluxcd.git \
	--branch=dev \
	--path=clusters/home \
	--private-key-file=/${HOME}/.ssh/id_ed25519

get-admin-argo-creds:
	bash ./scripts/get_creds.sh


apply-argo-repo-creds:
	kubectl apply -f repo-creds.yaml

create-regcred:
	kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/ciaran.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson