if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

if [[ -f "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh" ]]; then
    . "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh"
fi
