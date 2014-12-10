# path aliases {{{
# use `cd ~xxx' to access
hash -d DOCS="${HOME}/Documents"
hash -d DOWN="${HOME}/Downloads"
if [ -d "${HOME}/Workspace" ]; then
    hash -d WORK="${HOME}/Workspace"
elif [ -d "${HOME}/Developer" ]; then
    hash -d WORK="${HOME}/Developer"
fi
#}}}

alias help=run-help
