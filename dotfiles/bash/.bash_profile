if builtin command -v zsh  > /dev/null; then
  exec zsh
else
  source .bashrc
fi
