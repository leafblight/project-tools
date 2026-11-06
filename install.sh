#!/usr/bin/env bash
# Symlinks everything in ./bin into ~/.local/bin (so `git pull` updates tools) and ensures it's on PATH.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin"
DEST_DIR="${DEST_DIR:-$HOME/.local/bin}"

mkdir -p "$DEST_DIR"

for f in "$SRC_DIR"/*; do
  [[ -f "$f" ]] || continue
  chmod +x "$f"
  name="$(basename "$f")"
  target="$DEST_DIR/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "skip   $name (real file exists at $target)"
    continue
  fi
  ln -sfn "$f" "$target"
  echo "linked $name -> $target"
done

case ":$PATH:" in
  *":$DEST_DIR:"*) exit 0 ;;
esac

case "$(basename "${SHELL:-bash}")" in
  zsh)  rc="$HOME/.zshrc" ;;
  bash) rc="$HOME/.bashrc" ;;
  *)    rc="$HOME/.profile" ;;
esac

line="export PATH=\"$DEST_DIR:\$PATH\""
if ! grep -qsF "$line" "$rc"; then
  printf '\n# workflow-tools\n%s\n' "$line" >> "$rc"
  echo "added $DEST_DIR to PATH in $rc — restart your shell or run: source $rc"
fi
