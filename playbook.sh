#!/bin/bash

DIR="${BASH_SOURCE%/*}"
export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"

function list_playbooks {
	#COMMANDS=$(find $DIR/scripts -type f | grep "\.command\.sh$" | sed "s|.*/\([a-zA-Z_-]*\)\.command\.sh$|\1|g" | sort)
	local playbooks=$(find $DIR/playbooks -name "*.yaml" -type f | sed 's/\.\/playbooks\///g;s/.yaml//g' | sort)
	echo "Available playbooks:"
	for playbook in $playbooks; do
		echo "$playbook"
	done
}

PLAYBOOK="playbooks/$1.yaml"
shift

if [ ! -f "$PLAYBOOK" ]; then
	echo "No playbook specified!"
	list_playbooks
	exit
fi

ansible-playbook -i ./inventory.yaml -e @vars.yaml --vault-password-file ./ansible_encryption_password $PLAYBOOK $@

