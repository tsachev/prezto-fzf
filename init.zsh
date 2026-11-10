#
# Loads fzf key bindings and completion.
#

# Return if requirements are not found.
if (( ! $+commands[fzf] )); then
  return 1
fi

# Use fd for file and directory listings when available (respects .gitignore).
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d'
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Inside tmux open fzf in a popup, otherwise use a bottom pane with the prompt
# below the list.
if [[ -n "$TMUX" ]]; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--tmux center,80%,70% --layout=reverse --border"
else
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--height=40% --layout=reverse --border"
fi

source <(fzf --zsh)
