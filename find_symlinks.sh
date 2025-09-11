find ~ -type l -exec sh -c '
  for link; do
    target=$(readlink -f "$link") || continue
    case "$target" in
      /home/atj/source/dotfiles/*) echo "$link -> $target" ;;
    esac
  done
' sh {} +
