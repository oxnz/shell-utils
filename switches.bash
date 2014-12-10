#!/bin/bash
# Author: Oxnz

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
shopt -s histappend     # append to the history file, don't overwrite it
#shopt -s cdspell		# Correct minor misspelling
shopt -s dotglob		# Includes dotfiles in path expansion
shopt -s checkwinsize	# Redraw contents if win size changes
shopt -s cmdhist		# Multiline cmd records as one cmd in history
shopt -s extglob		# Allow basic regexps in bash
#shopt -s histverify     # Allow further modification other than exec immediately
#shopt -s lithist        # Preserve the multiline history
