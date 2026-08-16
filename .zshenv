# .zshenv —— 所有 zsh 都会读，包括脚本、cron、LaunchAgent。
# 交互式专属的东西（提示符、补全、别名、mise 的 cd 即切）留在 .zshrc。
#
# 这里只补「脚本也需要」的最小集合。与 .zshrc 里的设置重叠是有意为之：
# typeset -U 会去重，且 .zshrc 的 prepend 在后执行，交互式下的优先级顺序不受影响。
typeset -U path fpath

export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

path=(
  "$HOME/.local/bin"                            # uv / claude / codex / herdr
  "$HOME/.local/share/mise/shims"               # node / pnpm / ni 兜底：shim 自己解析当前
                                                # 目录该用哪个版本，不要写死版本号。交互式下
                                                # mise activate 会把 installs 插到更前面，
                                                # 版本切换不受影响
  "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"  # GNU tar 覆盖系统 bsdtar。
                                                 # 放这里是为了让 `zsh -c` 跑的脚本
                                                 # 和交互式用到同一个 tar —— 两者
                                                 # 在 --wildcards / --transform 上行为不同
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  $path
)

. "$HOME/.cargo/env"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
