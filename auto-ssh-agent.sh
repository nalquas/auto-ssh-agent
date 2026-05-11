#!/bin/bash

_auto-ssh-agent-load-agent() {
	local file="$XDG_RUNTIME_DIR/.ssh-agent.env"

	# Verify ownership & permissions
	if [[ ! -f $file || $(stat -c '%u:%g:%a' "$file") != "$UID:$(id -g):600" ]]; then
		echo "Unsafe ssh-agent environment file: $file"
		return 1
	fi

	# Parse safely
	# NOTE: this is done instead of a simple source call to avoid security issues with potential arbitrary code execution
	local sock pid
	while read -r line; do
		case "$line" in
		SSH_AUTH_SOCK=*)
			sock=${line#*=}
			sock=${sock%%;*}
			;;
		SSH_AGENT_PID=*)
			pid=${line#*=}
			pid=${pid%%;*}
			;;
		esac
	done <"$file"

	export SSH_AUTH_SOCK="$sock"
	export SSH_AGENT_PID="$pid"
}

_auto-ssh-agent-create-new-agent() {
	local file="$XDG_RUNTIME_DIR/.ssh-agent.env"
	ssh-agent -t "${1:-10h}" >"$file"
	chmod 600 "$file"
}

auto-ssh-agent() {
	echo -n "Preparing ssh-agent ... "
	local lifetime="${1:-10h}"

	if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
		echo "XDG_RUNTIME_DIR is not set, cannot manage ssh-agent environment file!"
		return 1
	fi

	if ! pgrep -x -u "$USER" ssh-agent >/dev/null; then
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

# Automatically run the function with the first argument as lifetime, or default to 10 hours
auto-ssh-agent "${1:-10h}"
