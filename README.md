# auto-ssh-agent

Shell startup script for automatically starting and connecting ssh-agent. To add ssh keys to the agent until reboot or the configured timeout, use `ssh-add`.

## Installation

Add the following to your `.bashrc` or `.zshrc` file (and adjust the path):

```sh
# Activate auto-ssh-agent
source /path/to/auto-ssh-agent/auto-ssh-agent.sh
auto-ssh-agent 10h
```

You can vary the lifetime of the ssh-agent as wanted, e.g. `2h`. If no lifetime is given, it defaults to `10h`.
