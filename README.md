# auto-ssh-agent

Shell startup script for automatically starting and connecting ssh-agent. To add ssh keys to the agent until reboot or the configured 10 hour timeout, use `ssh-add`.

## Installation

### Bash

Add the following to your `.bashrc` file (and adjust the path):

```sh
# Activate auto-ssh-agent
. /path/to/auto-ssh-agent/auto-ssh-agent.sh
```

### Zsh

Add the following to your `.zshrc` file (and adjust the path):

```sh
# Activate auto-ssh-agent
source /path/to/auto-ssh-agent/auto-ssh-agent.sh
```
