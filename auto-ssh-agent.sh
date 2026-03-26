#!/bin/bash

_auto-ssh-agent-load-agent() {
	source "$XDG_RUNTIME_DIR/.ssh-agent.env" >/dev/null
}

_auto-ssh-agent-create-new-agent() {
	ssh-agent -t "${1:-10h}" >"$XDG_RUNTIME_DIR/.ssh-agent.env"
}

auto-ssh-agent() {
	echo -n "Preparing ssh-agent ... "
	lifetime="${1:-10h}"

	if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
		echo "XDG_RUNTIME_DIR is not set, cannot manage ssh-agent environment file!"
		return 1
	fi

	if ! pgrep -u "$USER" ssh-agent >/dev/null; then
		echo -n "no ssh-agent running, starting a new one ... "
		_auto-ssh-agent-create-new-agent "$lifetime"
	elif [ ! -f "$XDG_RUNTIME_DIR/.ssh-agent.env" ]; then
		# HACK: workaround needed to work on Ubuntu, which likes starting its own ssh-agent that we can't use easily
		echo -n "inaccessible ssh-agent running, starting a new one ... "
		_auto-ssh-agent-create-new-agent "$lifetime"
	fi
	echo -n "connecting ... "
	_auto-ssh-agent-load-agent
	echo "done!"
}
