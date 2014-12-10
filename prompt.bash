#!/bin/bash
# Author: Oxnz

function prompt_command() {
    GIT_PS1_SHOWUPSTREAM='auto' \
    GIT_PS1_SHOWDIRTYSTATE='Y' \
    GIT_PS1_SHOWSTASHSTATE='Y' \
    GIT_PS1_SHOWCOLORHINTS='Y' \
    GIT_PS1_SHOWUNTRACKEDFILES='Y' \
	__git_ps1 "(%s)"
}

# this may cause bash prompt messed up
#PROMPT_COMMAND=prompt_command
