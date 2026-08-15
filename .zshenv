# .zshenv —— 所有 zsh 都会读，包括脚本、cron、LaunchAgent。
# 交互式专属的东西（提示符、补全、别名、fnm 的 use-on-cd）留在 .zshrc。
#
# 这里只补「脚本也需要」的最小集合。与 .zshrc 里的设置重叠是有意为之：
# typeset -U 会去重，且 .zshrc 的 prepend 在后执行，交互式下的优先级顺序不受影响。
typeset -U path fpath

export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

path=(
  "$HOME/.local/bin"                            # uv / claude / codex / herdr
  "$HOME/.local/share/fnm/aliases/default/bin"  # node 兜底：跟随 fnm 的 default 别名，
                                                # 不要写死版本号。交互式下 fnm env 会把
                                                # multishell 目录插到更前面，版本切换不受影响
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  $path
)

. "$HOME/.cargo/env"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
