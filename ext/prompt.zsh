# ~/.shell/prompt.zsh
# see zshmisc(1)

PROMPT="%F{cyan}[%F{red}%n%F{green}@%F{blue}%m:%F{magenta}%1~:%F{red}%?%F{cyan}]%#%f "
RPROMPT="%F{cyan}%*%f"

# set terminal title
case $TERM in
	(*xterm(-256color|)|*rxvt*|(dt|k|E)term)
		function set_term_title_precmd() {
			print -Pn "\e]0;%n@%M:%/\a"
		}
		function set_term_title_preexec() {
			print -Pn "\e]0;%n@%M:%/\:$1\a"
		}
		;;
esac

local -a precmd_functions
precmd_functions+=set_term_title_precmd
