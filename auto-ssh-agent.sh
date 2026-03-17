# NOTE: no shebang added on purpose because this may be imported into different shells, like bash or zsh

# Create a helper function for quickly setting up ssh-agent when needed
auto-ssh-agent() {
    echo "Preparing ssh-agent ..."
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        echo "There is no ssh-agent running, starting a new one ..."
        ssh-agent -t 10h > "$XDG_RUNTIME_DIR/.ssh-agent.env"
        source "$XDG_RUNTIME_DIR/.ssh-agent.env" > /dev/null
    elif [[ ! "$SSH_AGENT_PID" ]]; then
        if [ -f "$XDG_RUNTIME_DIR/.ssh-agent.env" ]; then
            echo "There already is an ssh-agent running, connecting to it ..."
            source "$XDG_RUNTIME_DIR/.ssh-agent.env" > /dev/null
        else
            # HACK: workaround needed to work on Ubuntu, which likes starting its own ssh-agent that we can't use easily
            echo "There is no ssh-agent running, starting a new one ..."
            ssh-agent -t 10h > "$XDG_RUNTIME_DIR/.ssh-agent.env"
            source "$XDG_RUNTIME_DIR/.ssh-agent.env" > /dev/null
        fi
    else
        echo "Already connected to an ssh-agent!"
    fi
    echo "... done!"
}

# Load SSH stuff
auto-ssh-agent
