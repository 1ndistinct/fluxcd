CURRENT_DIR:=$(shell pwd)
SHELL:=/bin/bash

provision:	
	flux bootstrap git \
	--url=ssh://git@github.com/1ndistinct/fluxcd.git \
	--branch=dev \
	--path=clusters/home \
	--private-key-file=/${HOME}/.ssh/id_ed25519

get-admin-argo-creds:
	bash -c " \
	namespace=argocd; \ 
	secret=argocd-initial-admin-secret; \
    secret=$(kubectl get secret -n $namespace $secret -o json); \
	password_key=password; \
	bash ./scripts/get_creds.sh"


apply-argo-repo-creds:
	kubectl apply -f repo-creds.yaml

create-regcred:
	kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/ciaran.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson