# homebrew {
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# when running in x86_64 using rosetta
    eval "$(/usr/local/bin/brew shellenv)"
fi
# }

# gpg {
export GPG_TTY=$(tty)
# }

# jenv {
eval "$(jenv init -)"
# }

# starship {
eval "$(starship init zsh)"
# }

# fnm {
eval "$(fnm env --use-on-cd --shell zsh)"
# }
