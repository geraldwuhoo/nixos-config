bindkey "^w" backward-kill-word
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^u" kill-whole-line
bindkey "^[b" emacs-backward-word
bindkey "^[f" emacs-forward-word

magic-enter () {
  # If commands are not already set, use the defaults
  [ -z "$MAGIC_ENTER_GIT_COMMAND" ] && MAGIC_ENTER_GIT_COMMAND="git status -u . && ls -lh"
  [ -z "$MAGIC_ENTER_OTHER_COMMAND" ] && MAGIC_ENTER_OTHER_COMMAND="ls -lh ."

  if [[ -z $BUFFER ]]; then
    echo ""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      eval "$MAGIC_ENTER_GIT_COMMAND"
    else
      eval "$MAGIC_ENTER_OTHER_COMMAND"
    fi
    zle redisplay
  else
    # zsh-abbr's accept-line, so abbreviations still expand on enter
    zle accept-line
  fi
}
zle -N magic-enter
bindkey "^M" magic-enter

# literal space without expanding an abbreviation (zsh-abbr also binds ctrl+space)
bindkey "^x " magic-space
