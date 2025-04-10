if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

if [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}" ]]; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

if [[ -f "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh" ]]; then
    . "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
