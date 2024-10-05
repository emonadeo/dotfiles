# homebrew {
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# when running in x86_64 using rosetta
    eval "$(/usr/local/bin/brew shellenv)"
fi
# }

# nvm {
export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
# }

# pnpm {
export PNPM_HOME="/Users/emonadeo/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# }

# go {
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
# }

# gpg {
export GPG_TTY=$(tty)
# }

# jenv {
eval "$(jenv init -)"
# }

# ruby {
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# }

# starship {
eval "$(starship init zsh)"
# }

# fnm {
eval "$(fnm env --use-on-cd --shell zsh)"
# }
