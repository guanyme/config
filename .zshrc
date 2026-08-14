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

eval "$(starship init zsh)"

export EDITOR='cursor'

[ -r "$HOME/.tauri/tauri.key" ] && export TAURI_SIGNING_PRIVATE_KEY="$(<"$HOME/.tauri/tauri.key")"
[ -r "$HOME/.tauri/tauri.pass" ] && export TAURI_SIGNING_PRIVATE_KEY_PASSWORD="$(<"$HOME/.tauri/tauri.pass")"

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

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
# fpath 与 compinit 已上移到 oh-my-zsh 之前统一处理
# <<< grok installer <<<

# ---- PATH ----
# 最终优先级（高 → 低），由各处 prepend 的先后决定，越晚 prepend 的越靠前：
#   ~/.vite-plus/bin  →  ~/.bun/bin  →  fnm multishell  →  ~/.local/bin
#   →  maven  →  gnu-tar  →  ~/.grok/bin  →  homebrew  →  系统
#
# 两条硬性要求：
#   1. fnm 的 multishell 必须压过 homebrew，否则 node 走 brew 那份
#   2. 不要再往前插任何写死版本号的 node 路径 —— 那会让 fnm 的版本切换
#      静默失效（fnm current 显示已切换，node --version 却不变）
PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/gnu-tar/libexec/gnubin:$PATH"   # GNU tar 覆盖系统 bsdtar

# Docker CLI completions —— fpath 与 compinit 已上移到 oh-my-zsh 之前统一处理

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"

export MAVEN_HOME="/usr/local/maven"
export PATH="$MAVEN_HOME/bin:$PATH"

. "$HOME/.local/bin/env"

# fnm —— 只 eval 一次；此前多余的 `fnm env --shell zsh` 会额外创建一份 multishell 目录
FNM_PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled --resolve-engines)"
fi

# git —— 取代 oh-my-zsh 的 git 插件（它一次性塞了 197 个别名，只留常用的）
alias g="git"
alias gaa="git add --all"
alias gcmsg="git commit --message"
alias gp="git push"
alias gl="git pull"
alias gcl="git clone --recurse-submodules"

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

# bun completions
[ -s "/Users/guany/.bun/_bun" ] && source "/Users/guany/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
