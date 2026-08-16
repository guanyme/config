# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# path/fpath 去重（保留首次出现，即优先级最高的那个）。
# .zprofile 的 brew shellenv 已经加过 site-functions，这里再加是重复的
typeset -U path fpath

# 所有补全目录必须在 source oh-my-zsh.sh 之前加入 fpath，
# 交给 oh-my-zsh 内部的单次 compinit 统一处理（此前 grok / Docker 各自又调了一次 compinit）
FPATH="${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions:${FPATH}"
fpath=(~/.grok/completions/zsh ~/.docker/completions $fpath)

# compaudit 已确认无权限异常的补全目录，跳过每次启动的重复安全扫描
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ═══════════════════════════════════════════════════════════════════
# 以下按「由内向外」分层：提示符 → 环境变量 → 语言运行时 → 通用工具
#                        → PATH 优先级 → 别名 → 函数
#
# 层内顺序不影响命令解析；唯一必须保证的顺序集中在「PATH 优先级」一节。
# ═══════════════════════════════════════════════════════════════════

# ── 提示符 ─────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── 环境变量 ───────────────────────────────────────────────────────
export EDITOR='code'
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"
export MAVEN_HOME="/usr/local/maven"
export BUN_INSTALL="$HOME/.bun"

# Tauri 更新签名 —— 见文件末尾的 tauri-sign 函数。
# 私钥不再全局 export：一旦进了环境变量，所有子进程都能读到
# （npm postinstall、CLI 的崩溃上报、agent 的 env dump 都会顺带带走）。

# ── 语言运行时（按使用频率）─────────────────────────────────────────
# node —— 只 eval 一次；多余的 `fnm env --shell zsh` 会再创建一份 multishell 目录
FNM_PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled --resolve-engines)"
fi

# bun
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# python —— 由 uv 托管
. "$HOME/.local/bin/env"

# java
export PATH="$MAVEN_HOME/bin:$PATH"

# ── 通用工具（按字母）───────────────────────────────────────────────
# docker —— 补全的 fpath 与 compinit 已上移到 oh-my-zsh 之前统一处理。
# Docker Desktop 更新时可能把它自己的那段重新追加到本文件末尾，届时删掉即可
# gnu-tar —— 已上移到 .zprofile，那里对非交互登录 shell 也生效

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
# fpath 与 compinit 已上移到 oh-my-zsh 之前统一处理
# <<< grok installer <<<

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# ── PATH 优先级 ────────────────────────────────────────────────────
# 实测各目录提供的命令集合，只有下面几组真正重叠，其余目录顺序随意：
#
#   ~/.local/bin  >  /opt/homebrew/bin   python3、python3.14
#   ~/.local/bin  >  ~/.grok/bin         agent、grok
#   gnu-tar       >  /usr/bin            tar、man    ← 在上面 prepend 即满足
#   homebrew      >  /usr/bin            git 等      ← 同上
#
# fnm 的 multishell 不必钉住：homebrew 不提供 node / npm / bun。
# 但绝不要往前插写死版本号的 node 路径 —— 那会让 fnm 的版本切换静默失效
# （fnm current 显示已切换，node --version 却纹丝不动）。
#
# 因此只需要这一条：uv 的 env 脚本发现 ~/.local/bin 已在 PATH 中就会跳过，
# 于是它停在 .zshenv 放的靠后位置，压不过 homebrew 与 ~/.grok/bin
path=("$HOME/.local/bin" $path)

# ── 别名 ───────────────────────────────────────────────────────────
# git —— 取代 oh-my-zsh 的 git 插件（它一次塞进 197 个别名，只留常用的）
alias g="git"
alias gaa="git add --all"
alias gcmsg="git commit --message"
alias gp="git push"
alias gl="git pull"
alias gcl="git clone --recurse-submodules"

# ni / nr
alias nio="ni --prefer-offline"
alias s="nr start"
alias d="nr dev"
alias b="nr build"
alias bw="nr build --watch"
alias t="nr test"
alias tu="nr test -u"
alias tw="nr test --watch"
alias w="nr watch"
alias p="nr play"
alias c="nr typecheck"
alias lint="nr lint"
alias lintf="nr lint --fix"
alias release="nr release"
alias re="nr release"

# ── 函数 ───────────────────────────────────────────────────────────
i() {
  cd ~/i/$1
}

codex() {
  local base_args="--dangerously-bypass-approvals-and-sandbox"

  command codex ${=base_args} resume --last "$@" 2>/dev/null || command codex ${=base_args} "$@"
}

claude() {
  local base_args="--allow-dangerously-skip-permissions --permission-mode plan"

  command claude ${=base_args} -c "$@" 2>/dev/null || command claude ${=base_args} "$@"
}

# Tauri 更新签名的按需注入。密钥只在被包装的这条命令的生命周期内存在，
# 不会常驻环境、也不会被无关的子进程继承。用法：
#   tauri-sign nr build
#   tauri-sign pnpm tauri build
tauri-sign() {
  local k="$HOME/.tauri/tauri.key" p="$HOME/.tauri/tauri.pass"
  [ -r "$k" ] || { print -u2 "tauri-sign: 缺少 $k"; return 1 }
  [ -r "$p" ] || { print -u2 "tauri-sign: 缺少 $p"; return 1 }
  [ $# -gt 0 ] || { print -u2 "用法: tauri-sign <命令> [参数...]"; return 2 }
  TAURI_SIGNING_PRIVATE_KEY="$(<"$k")" \
  TAURI_SIGNING_PRIVATE_KEY_PASSWORD="$(<"$p")" \
    "$@"
}



# ── PATH 顺序 ──────────────────────────────────────────────────────
# 放在最后统一排一次。理由：各处 prepend 的先后决定不了最终顺序 ——
# /etc/zprofile 的 path_helper 会把系统路径整体提前，安装器还会往本文件
# 末尾追加自己的 env 脚本。与 Windows 注册表 PATH 用同一套分档，三端一致：
#   10 语言运行时 → 20 GNU 工具 → 40 应用 → 50 系统/包管理器
__path_rank() {
  case "$1" in
    */.local/bin)                            print 10 ;;  # uv 的 python / claude / codex / herdr
    */fnm_multishells/*)                     print 11 ;;  # 当前会话选中的 node
    */.bun/bin)                              print 12 ;;
    */.deno/bin)                             print 13 ;;
    */.cargo/bin)                            print 14 ;;
    */maven/bin)                             print 15 ;;
    */miniconda3/bin|*/miniconda3/condabin)  print 16 ;;
    */fnm/aliases/default/bin)               print 19 ;;  # node 兜底，必须排在 multishell 之后
    */gnubin)                                print 20 ;;  # GNU tar 覆盖系统 bsdtar
    */.vite-plus/bin)                        print 40 ;;
    */.grok/bin)                             print 41 ;;
    */.opencode/bin)                         print 42 ;;
    /opt/homebrew/bin|/opt/homebrew/sbin)    print 50 ;;
    /usr/local/*)                            print 51 ;;
    /usr/bin|/bin|/usr/sbin|/sbin)           print 52 ;;
    # 苹果自带的系统路径（来自 /etc/paths 与 /etc/paths.d），一律垫底
    /System/Cryptexes/*|/var/run/com.apple.security.cryptexd/*) print 53 ;;
    /Library/Apple/*|/usr/ucb|/pkg/env/*)    print 53 ;;
    *)                                       print 45 ;;  # 未识别：夹在应用与系统之间
  esac
}
path=(${(@f)"$(for __p in $path; do print -r -- "$(__path_rank $__p)|$__p"; done | sort -t'|' -k1,1n -s | cut -d'|' -f2-)"})
unset __p
