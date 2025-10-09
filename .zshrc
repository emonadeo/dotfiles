bindkey -v

# deno {
export PATH="/Users/emonadeo/.deno/bin:$PATH"
# }

# gpg {
export GPG_TTY=$(tty)
# }

# homebrew {
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# when running in x86_64 using rosetta
    eval "$(/usr/local/bin/brew shellenv)"
fi
# }

# jenv {
eval "$(jenv init -)"
# }

# starship {
eval "$(starship init zsh)"
# }
