# Copyright (c) 2014 0xnz. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ~/.zshrc
#
# Created: 2013-06-25 12:20:00
# Last-update: 2014-11-03 15:50:55
# Version: 0.1
# Author: Oxnz
# License: Copyright (C) 2013 Oxnz
# Reference: http://grml.org/zsh/zsh-lovers.html

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export LC_ALL=en_US.UTF-8

#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:git*:*' git-revision true
#zstyle ':vcs_info:git*:*' check-for-changes false
#zstyle ':vcs_info:git*' formats "(%s) %12.12i %c%u %b%m"
#zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.12i %c%u %b%m"

# Utils settings {{{
# Key bindings
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
#bindkey "\e[1~" beginning-of-line # Home
#bindkey "\e[4~" end-of-line # End
#bindkey -v
#bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~"	delete-char	# Del
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
# Ctrl+U to be bound to backward-kill-line rather than kill-whole-line
bindkey \^U backward-kill-line

#following chars are regareds as part of the word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

# completion {{{
#setopt AUTO_MENU
#with AUTO_LIST set, when the completion is ambiguous you get a list without
#having to type ^D
setopt AUTO_LIST
#开启此选项，补全时会直接选中菜单项
#setopt MENU_COMPLETE
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
if whence dircolors >/dev/null; then
	eval "$(dircolors -b)"
else
	export CLICOLOR=1
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,%mem,tty,cputime,command'
#自动补全缓存
#zstyle ':complete::complete:*' use-cache on
#zstyle ':complete::complete:*' cache-path .zcache
#zstyle ':complete:*:cd:*' ignore-parents parent pwd

#自动补全选项
#zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect: lines: %L matches: %M [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path completion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

# Colorful menu completion
#eval $(dircolors -b)
#export ZLSCOLORS="${LS_COLORS}"
#zmodload zsh/complist
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Fix upper and lower case
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# correction
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Kill completion
zstyle ':completion:*:*:kill' menu yes select
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
compdef pkill=kill
compdef killall=kill

#补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}


##行编辑高亮模式 {{{
# Ctrl+@ 设置标记，标记和光标点之间为 region
zle_highlight=(region:bg=magenta #选中区域
special:bold      #特殊字符
isearch:underline)#搜索时使用的关键字
#}}}
 
##空行(光标在行首)补全 "cd " {{{
user-complete(){
	case $BUFFER in
	"" )                       # 空行填入 "cd "
		BUFFER="cd "
		zle end-of-line
		zle expand-or-complete
		;;
	"cd --" )                  # "cd --" 替换为 "cd +"
		BUFFER="cd +"
		zle end-of-line
		zle expand-or-complete
		;;
	"cd +-" )                  # "cd +-" 替换为 "cd -"
		BUFFER="cd -"
		zle end-of-line
		zle expand-or-complete
		;;
	* )
		zle expand-or-complete
		;;
	esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}
 
##在命令前插入 sudo {{{
#定义功能
sudo-command-line() {
	[[ -z $BUFFER ]] && zle up-history
	[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
	zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#}}}

#aliases {{{
#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
 
#历史命令 top10
#alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

        
#自定义补全{{{
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com
 
#补全 ssh scp sftp 等
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#}}}

#{{{ F1 计算器
arith-eval-echo() {
LBUFFER="${LBUFFER}echo \$(( "
RBUFFER=" ))$RBUFFER"
}
zle -N arith-eval-echo
bindkey "^[[11~" arith-eval-echo
#}}}
 
####{{{
#function timeconv { date -d @$1 +"%Y-%m-%d %T" }
# }}}

zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup

#漂亮又实用的命令高亮界面
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

recolor-cmd() {
	local region_highlight=()
	local colorize=true
	local start_pos=0
	local arg
	for arg in ${(z)BUFFER}; do
		((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
		((end_pos=$start_pos+${#arg}))
		if $colorize; then
			colorize=false
			res=$(LC_ALL=C builtin type $arg 2>/dev/null)
			case $res in
				*'reserved word'*)   style="fg=magenta,bold";;
				*'alias for'*)       style="fg=cyan,bold";;
				*'shell builtin'*)   style="fg=yellow,bold";;
				*'shell function'*)  style='fg=green,bold';;
				*"$arg is"*)
					[[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
				*)                   style='none,bold';;
			esac
			region_highlight+=("$start_pos $end_pos $style")
		fi
		[[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
		start_pos=$end_pos
	done
}
#check-cmd-self-insert() { zle .self-insert && recolor-cmd || echo "failed" }
#check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd || echo "failed" }

#zle -N self-insert check-cmd-self-insert
#zle -N backward-delete-char check-cmd-backward-delete-char

# source common utilites
if [ -d ~/.shell ]; then
	for i in ~/.shell/*.{z,}sh(N); do
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi
