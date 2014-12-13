# ~/.shell/switches.zsh

HISTFILE=~/.zsh_history
# command not found support
[[ -r /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# disable core dumps
limit coredumpsize 0
#扩展路径
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word

# spelling correction options
#setopt CORRECT

# prompt for confirmation after 'rm *', etc.
#setopt RM_STAR_WAIT
# don't write over existing files with >, use >! instead
setopt NOCLOBBER
#允许在交互模式中使用注释  例如：
setopt INTERACTIVE_COMMENTS
#启用自动 cd，输入目录名回车进入目录,稍微有点混乱，不如 cd 补全实用
setopt AUTO_CD

# If the EXTENDED_GLOB option is set, the ^, ~, and # characters also denote
# a pattern, some command depends on this special characters need to escape
# slash, like `git reset HEAD\^`, U can also `alias git="noglob git"`, a 3rd
# option: % noglob git show HEAD^
setopt EXTENDED_GLOB

#setopt correctall
autoload compinstall

setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
# When using a hist thing, make a newline show the change before exec it.
setopt HIST_VERIFY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE

#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS

