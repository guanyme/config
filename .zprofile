
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# ── PATH 优先级（登录 shell）────────────────────────────────────────
# 必须放在这里，不能只放 .zshrc：
#   /etc/zprofile 会调用 path_helper，把 /etc/paths 和 /etc/paths.d/* 里的
#   系统路径整体重排到最前，.zshenv 设的用户目录会被压到 /usr/bin 之后。
#   本文件在 path_helper 之后执行，且登录 shell（交互与非交互）都会读，
#   所以在这里重新确立优先级，`ssh 本机 '命令'` 之类的非交互场景才不会降级。
#
# 不这么做的话，同一个命令在两种场景下解析到不同实现：
#   zsh -lic  python3 → ~/.local/bin（uv）   tar → gnu-tar
#   zsh -lc   python3 → homebrew            tar → bsdtar
typeset -U path fpath

path=(
  "$HOME/.local/bin"                                            # uv / claude / codex / herdr
  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/gnu-tar/libexec/gnubin" # GNU tar 覆盖系统 bsdtar
  $path
)
