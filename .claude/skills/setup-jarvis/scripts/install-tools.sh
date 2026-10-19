#!/bin/bash
# Jarvis tools: installs what Jarvis needs without admin rights or a terminal.
#   node  -> memory hooks (.claude/hooks/*.mjs)
#   git   -> version history (/save)
#   gh    -> GitHub login + private backup repo (/save)
# Idempotent: anything already installed is skipped. Ends with one STATUS line per tool.
# macOS/Linux: official downloads into ~/.local (checksum-verified, no sudo).
# Windows (Git Bash): winget, which may show one "allow changes" popup.
set -u

BIN="$HOME/.local/bin"
TOOLS="$HOME/.local/share/jarvis-tools"
mkdir -p "$BIN" "$TOOLS"
export PATH="$BIN:$PATH"
OS=$(uname -s)
ARCH=$(uname -m)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
RESTART=no

have() { command -v "$1" >/dev/null 2>&1; }
say() { echo "[jarvis] $*"; }
sha256() { if have shasum; then shasum -a 256 "$1"; else sha256sum "$1"; fi | cut -d' ' -f1; }

# Apps started later (the Claude desktop app) read the login shell's PATH, so ~/.local/bin goes there.
ensure_path_line() {
  case "${SHELL:-}" in */bash) rc="$HOME/.bash_profile" ;; *) rc="$HOME/.zprofile" ;; esac
  if ! grep -qs '.local/bin' "$rc"; then
    printf '\n# Added by Jarvis setup\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$rc"
    say "added ~/.local/bin to PATH in $rc"
  fi
}

# Download $1 to $2 and check it against sha256 $3.
fetch_verified() {
  curl -fsSL "$1" -o "$2" || return 1
  [ "$(sha256 "$2")" = "$3" ] || { say "checksum mismatch for $1"; return 1; }
}

node_ok() { have node && [ "$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)" -ge 18 ]; }

install_node() {
  case "$OS-$ARCH" in
    Darwin-arm64) plat=darwin-arm64 ;;
    Darwin-x86_64) plat=darwin-x64 ;;
    Linux-x86_64) plat=linux-x64 ;;
    Linux-aarch64) plat=linux-arm64 ;;
    *) return 1 ;;
  esac
  base="https://nodejs.org/dist/latest-v24.x"
  line=$(curl -fsSL "$base/SHASUMS256.txt" | grep -- "-$plat.tar.gz$") || return 1
  sum=${line%% *}; file=${line##* }; dir=${file%.tar.gz}
  fetch_verified "$base/$file" "$TMP/$file" "$sum" || return 1
  tar -xzf "$TMP/$file" -C "$TOOLS" || return 1
  for b in node npm npx; do ln -sf "$TOOLS/$dir/bin/$b" "$BIN/$b"; done
}

install_gh() {
  case "$OS-$ARCH" in
    Darwin-arm64) plat=macOS_arm64; ext=zip ;;
    Darwin-x86_64) plat=macOS_amd64; ext=zip ;;
    Linux-x86_64) plat=linux_amd64; ext=tar.gz ;;
    Linux-aarch64) plat=linux_arm64; ext=tar.gz ;;
    *) return 1 ;;
  esac
  release=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest) || return 1
  tag=$(printf '%s\n' "$release" | grep -m1 '"tag_name"' | cut -d'"' -f4)
  [ -n "$tag" ] || return 1
  ver=${tag#v}; file="gh_${ver}_${plat}.${ext}"; base="https://github.com/cli/cli/releases/download/$tag"
  sum=$(curl -fsSL "$base/gh_${ver}_checksums.txt" | grep " $file$" | cut -d' ' -f1)
  [ -n "$sum" ] || return 1
  fetch_verified "$base/$file" "$TMP/$file" "$sum" || return 1
  if [ "$ext" = zip ]; then unzip -qo "$TMP/$file" -d "$TOOLS" || return 1; else tar -xzf "$TMP/$file" -C "$TOOLS" || return 1; fi
  ln -sf "$TOOLS/gh_${ver}_${plat}/bin/gh" "$BIN/gh"
}

winget_install() {
  winget.exe install -e --id "$1" --silent --accept-source-agreements --accept-package-agreements >/dev/null 2>&1
}

case "$OS" in
  MINGW*|MSYS*|CYGWIN*)
    node_ok || { say "installing Node.js"; winget_install OpenJS.NodeJS.LTS && RESTART=yes; }
    have gh || { say "installing GitHub CLI"; winget_install GitHub.cli && RESTART=yes; }
    # git ships with Git for Windows, which Claude Code on Windows already requires
    ;;
  *)
    ensure_path_line
    node_ok || { say "installing Node.js"; install_node && RESTART=yes; }
    have gh || { say "installing GitHub CLI"; install_gh; }
    if [ "$OS" = Darwin ] && ! xcode-select -p >/dev/null 2>&1; then
      say "git needs Apple's developer tools: opening the installer"
      xcode-select --install >/dev/null 2>&1
      GIT_PENDING=yes
    fi
    ;;
esac

status() { if have "$1"; then echo "STATUS $1=ok ($($1 --version 2>/dev/null | head -1))"; else echo "STATUS $1=${2:-missing}"; fi; }
node_ok && status node || echo "STATUS node=missing"
if [ "${GIT_PENDING:-no}" = yes ]; then echo "STATUS git=installing (click Install in the Apple popup, wait for it to finish)"; else status git; fi
status gh
echo "STATUS restart_claude_app=$RESTART"
