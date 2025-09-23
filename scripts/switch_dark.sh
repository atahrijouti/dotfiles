#!/bin/sh

UNAME="$(uname -s)"
case "$UNAME" in
  MSYS*|MINGW*|CYGWIN*)  # Windows (MSYS2)
    HELIX_CONFIG="$HOME/AppData/Roaming/helix"
    ;;
  *)
    HELIX_CONFIG="$HOME/.config/helix"
    ;;
esac

# apply sed
sed -i -E "s/(inherits\s=\s\").*(\")/\1my_jetbrains_dark\2/" "$HELIX_CONFIG/themes/site-theme.toml"
