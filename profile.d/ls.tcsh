if (! ${?prompt}) goto done

#
if ( -x /usr/bin/dircolors ) then
    if ( -r $HOME/.dir_colors ) then
	eval `/usr/bin/dircolors -c $HOME/.dir_colors`
    else if ( -r /etc/DIR_COLORS ) then
	eval `/usr/bin/dircolors -c /etc/DIR_COLORS`
    endif
endif
setenv LS_OPTIONS '--color=tty'
if ( ${?LS_COLORS} ) then
    if ( "${LS_COLORS}" == "" ) setenv LS_OPTIONS '--color=none'
endif
unalias ls
if ( "$uid" == "0" ) then
    setenv LS_OPTIONS "-A -N $LS_OPTIONS -T 0"
else
    setenv LS_OPTIONS "-N $LS_OPTIONS -T 0"
endif
alias ls 'ls $LS_OPTIONS'
alias la 'ls -aF --color=none'
alias ll 'ls -l  --color=none'
alias l  'll'
alias dir  'ls --format=vertical'
alias vdir 'ls --format=long'
alias d dir;
alias v vdir;

done:

