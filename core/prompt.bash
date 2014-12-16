# prompt for bash
# There are several variables that can be set to control the appearance of the
# bach command prompt: PS1, PS2, PS3, PS4 and PROMPT_COMMAND the contents are
# executed just as if they had been typed on the command line.

# PS1 – Default interactive prompt (this is the variable most often customized)
# PS2 – Continuation interactive prompt (when a long command is broken up
#	    with \ at the end of the line) default=">"
# PS3 – Prompt used by “select” loop inside a shell script
# PS4 – Prompt used when a shell script is executed in debug mode
#       (“set -x” will turn this on) default ="++"
# PROMPT_COMMAND - If this variable is set and has a non-null value, then it
#		will be executed just before the PS1 variable.
# quote from tldp:
#	Bash provides an environment variable called PROMPT_COMMAND. The contents
#	of this variable are executed as a regular Bash command just before Bash
#	displays a prompt.

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
