# /etc/profile.d/complete.bash for SUSE Linux and openSUSE
#
#
# This feature has its own file because some other shells
# do not like the way how the bash assigns arrays
#
# REQUIRES bash 4.2 and higher
#

 _def="-o default -o bashdefault"
 _dir="-o nospace -o dirnames -o plusdirs"
_file="-o nospace -o filenames"
_mkdr="-o nospace -o dirnames"
_nosp="-o nospace"

# Escape file and directory names, add slash to directories if needed.
# Escaping could be done by the option 'filenames' but this fails
# e.g. on variable expansion like $HO<TAB>
_compreply_ ()
{
    local IFS=$'\n'
    local s x
    local -i o
    local -i isdir=$1

    test ${#COMPREPLY[@]} -eq 0 && return 0

    #
    # Append a slash on the real result, avoid annoying double tab
    #
    for ((o=0; o < ${#COMPREPLY[@]}; o++)) ; do
	if test ! -d "${COMPREPLY[$o]}" ; then
	    ((isdir == 0)) || continue
	    COMPREPLY[$o]="${COMPREPLY[$o]%%/}"
	    continue
	fi
	COMPREPLY[$o]="${COMPREPLY[$o]%%/}/"
    done

    #
    # If we have only one entry, and it's a file-system object, but not
    # a directory, then indicate this by letting readline put a space behind
    # it.
    #
    if test ${#COMPREPLY[@]} -eq 1 ; then
	eval x="${COMPREPLY[@]}"
	if test -d "$x"
	then
	    compopt -o plusdirs
	    compopt +o nospace
	else
	    compopt -o nospace
	fi
    fi

    #
    # Escape spaces and braces in path names with `\'
    #
    s="${COMP_WORDBREAKS//[: ]}"
    s="${s//	}"
    s="${s//[\{\}()\[\]]}"
    s="${s} 	(){}[]\`\$"
    o=${#s}

    while test $((o--)) -gt 0 ; do
	x="${s:${o}:1}"
	case "$x" in
	\() COMPREPLY=($(echo "${COMPREPLY[*]}"|command sed -r 's/\(/\\\(/g')) ;;
	*)  COMPREPLY=(${COMPREPLY[*]//${x}/\\${x}}) ;;
	esac
    done
}

#
# Handle the CDPATH variable
#
_cdpath_ ()
{
    local -i o
    local c="$1"
    local x="$(bind -v | sed -rn 's/set (mark-)/\1/p')"
    local dir=$([[ $x =~ mark-directories+([[:space:]])on ]] && echo on)
    local sym=$([[ $x =~ mark-symlinked-directories+([[:space:]])on ]] && echo on)

    for x in ${CDPATH//:/$'\n'}; do
	o=${#COMPREPLY[@]}
	for s in $(compgen -d +o plusdirs $x/$c); do
	    if [[ (($sym == on && -h $s) || ($dir == on && ! -h $s)) && ! -d ${s#$x/} ]] ; then
		s="${s}/"
	    fi
	    COMPREPLY[o++]=${s#$x/}
	done
    done
}

# Expanding shell function for directories
_cd_ ()
{
    local c=${COMP_WORDS[COMP_CWORD]}
    local s x
    local IFS=$'\n'
    local -i glob=0
    local -i isdir=0
    local -i cdpath=0
    local -i quoted=0

    if [[ "${c:0:1}" == '"' ]] ; then
	let quoted++
	compopt -o plusdirs
    fi
   
    shopt -q extglob && let glob++
    ((glob == 0)) && shopt -s extglob

    if [[ $COMP_WORDBREAKS =~ : && $COMP_LINE =~ : ]] ; then
	# Do not use plusdirs as there is a colon in the directory
	# name(s) which will not work even if escaped with backslash.
	compopt +o plusdirs
	# Restore last argument without breaking at colon
	if ((COMP_CWORD > 1)) ; then
	    IFS="${COMP_WORDBREAKS//:}"
	    COMP_WORDS=($COMP_LINE)
	    let COMP_CWORD=${#COMP_WORDS[@]}-1
	    c=${COMP_WORDS[COMP_CWORD]}
	    IFS=$'\n'
	fi
    fi

    case "${1##*/}" in
    mkdir)  ;;
    cd|pushd)
	s="-S/"
	[[ "$c" =~ ^\..* ]] || let cdpath++ ;;
    *)	s="-S/"
    esac

    case "$c" in
    *[*?[]*)	COMPREPLY=()				# use bashdefault
		((cdpath == 0)) || _cdpath_ "$c"
		((glob == 0)) && shopt -u extglob
		return 0						;;
    \$\(*\))	eval COMPREPLY=\(${c}\)
		compopt +o plusdirs					;;
    \$\(*)	COMPREPLY=($(compgen -c -P '$(' -S ')'	-- ${c#??}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \`*\`)	eval COMPREPLY=\(${c}\)
		compopt +o plusdirs					;;
    \`*)	COMPREPLY=($(compgen -c -P '\`' -S '\`' -- ${c#?}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \$\{*\})	eval COMPREPLY=\(${c}\) ;;
    \$\{*)	COMPREPLY=($(compgen -v -P '${' -S '}'	-- ${c#??}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    if ((${#COMPREPLY[@]} > 1)) ; then
			((cdpath == 0)) || _cdpath_ "$c"
			((glob == 0)) && shopt -u extglob
			return 0
		    fi
		    let isdir++
		    eval COMPREPLY=\(${COMPREPLY[@]}\)
		fi							;;
    \$*)	COMPREPLY=($(compgen -v -P '$' $s	-- ${c#?}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    if ((${#COMPREPLY[@]} > 1)) ; then
			((cdpath == 0)) || _cdpath_ "$c"
			((glob == 0)) && shopt -u extglob
			return 0
		    fi
		    let isdir++
		    eval COMPREPLY=\(${COMPREPLY[@]}\)
		fi							;;
    \~*/*)	COMPREPLY=($(compgen -d $s +o plusdirs 	-- "${c}"))
		if ((${#COMPREPLY[@]} > 0)) ; then
 		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \~*)	COMPREPLY=($(compgen -u $s 		-- "${c}"))
		if ((${#COMPREPLY[@]} > 0)) ; then
 		    compopt +o plusdirs
		    let isdir++
		fi							;;
    *\:*)	if [[ $COMP_WORDBREAKS =~ : ]] ; then
		    x=${c%"${c##*[^\\]:}"}
		    COMPREPLY=($(compgen -d $s +o plusdirs -- "${c}"))
 		    COMPREPLY=(${COMPREPLY[@]#"$x"})
		    ((${#COMPREPLY[@]} == 0)) || let isdir++
		fi
		((cdpath == 0)) || _cdpath_ "$c"
		((glob == 0)) && shopt -u extglob
		return 0						;;
    *)		COMPREPLY=()				# use (bash)default
		((cdpath == 0)) || _cdpath_ "$c"
		((glob == 0)) && shopt -u extglob
		return 0						;;
    esac
    if test ${#COMPREPLY[@]} -gt 0 ; then
 	_cdpath_ "$c"
	((${#COMPREPLY[@]} == 0)) || let isdir++
    fi

    ((quoted)) || _compreply_ $isdir

    ((glob == 0)) && shopt -u extglob
    return 0
}

if shopt -q cdable_vars; then
    complete ${_def} ${_dir} -vF _cd_		cd
else
    complete ${_def} ${_dir}  -F _cd_		cd
fi
complete ${_def} ${_dir}  -F _cd_		rmdir pushd chroot chrootx
complete ${_def} ${_mkdr} -F _cd_		mkdir

# General expanding shell function
_exp_ ()
{
    # bash `complete' is broken because you can not combine
    # -d, -f, and -X pattern without missing directories.
    local c=${COMP_WORDS[COMP_CWORD]}
    local a="${COMP_LINE}"
    local e s cd dc t=""
    local -i o
    local -i glob=0 
    local -i quoted=0
    local IFS

    if [[ "${c:0:1}" == '"' ]] ; then
	let quoted++
	compopt -o plusdirs
    fi
   
    shopt -q extglob && let glob++
    ((glob == 0)) && shopt -s extglob

    # Don't be fooled by the bash parser if extglob is off by default
    cd='*-?(c)d*'
    dc='*-d?(c)*'

    case "${1##*/}" in
    compress)		e='*.Z'					;;
    bzip2)
	case "$c" in
	-)		COMPREPLY=(d c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
 	-?|-??)		COMPREPLY=($c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
	esac
	case "$a" in
	$cd|$dc)	e='!*.+(*)'
			t='@(bzip2 compressed)*'		;;
	*)		e='*.bz2'				;;
	esac							;;
    bunzip2)		e='!*.+(*)'
			t='@(bzip2 compressed)*'		;;
    gzip)
	case "$c" in
	-)		COMPREPLY=(d c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
 	-?|-??)		COMPREPLY=($c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
	esac
	case "$a" in
	$cd|$dc)	e='!*.+(*)'
			t='@(gzip compressed|*data 16 bits)*'	;;
	*)		e='*.+(gz|tgz|z|Z)'			;;
	esac							;;
    gunzip)		e='!*.+(*)'
			t='@(gzip compressed|*data 16 bits)*'	;;

    lzma)
	case "$c" in
	-)		COMPREPLY=(d c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
 	-?|-??)		COMPREPLY=($c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
	esac
	case "$a" in
	$cd|$dc)	e='!*.+(lzma)'				;;
	*)		e='*.+(lzma)'				;;
	esac							;;
    unlzma)		e='!*.+(lzma)'				;;
    xz)
	case "$c" in
	-)		COMPREPLY=(d c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
 	-?|-??)		COMPREPLY=($c)
			((glob == 0)) && shopt -u extglob
			return 0				;;
	esac
	case "$a" in
	$cd|$dc)	e='!*.+(xz)'				;;
	*)		e='*.+(xz)'				;;
	esac							;;
    unxz)		e='!*.+(xz)'				;;
    uncompress)		e='!*.Z'				;;
    unzip)		e='!*.+(*)'
			t="@(MS-DOS executable|Zip archive)*"	;;
    gs|ghostview)	e='!*.+(eps|EPS|ps|PS|pdf|PDF)'		;;
    gv|kghostview)	e='!*.+(eps|EPS|ps|PS|ps.gz|pdf|PDF)'	;;
    acroread|[xk]pdf)	e='!*.+(fdf|pdf|FDF|PDF)'		;;
    evince)		e='!*.+(ps|PS|pdf|PDF)'			;;
    dvips)		e='!*.+(dvi|DVI)'			;;
    rpm|zypper)		e='!*.+(rpm|you)'			;;
    [xk]dvi)		e='!*.+(dvi|dvi.gz|DVI|DVI.gz)'		;;
    tex|latex|pdflatex)	e='!*.+(tex|TEX|texi|latex)'		;;
    export)
	case "$a" in
	*=*)		c=${c#*=}				;;
	*)		COMPREPLY=($(compgen -v -- ${c}))
			((glob == 0)) && shopt -u extglob
			return 0				;;
	esac
	;;
    *)			e='!*'
    esac

    case "$(complete -p ${1##*/} 2> /dev/null)" in
	*-d*)	;;
	*) s="-S/"
    esac

    IFS=$'\n'
    case "$c" in
    \$\(*\))	   eval COMPREPLY=\(${c}\) ;;
    \$\(*)		COMPREPLY=($(compgen -c -P '$(' -S ')'  -- ${c#??}))	;;
    \`*\`)	   eval COMPREPLY=\(${c}\) ;;
    \`*)		COMPREPLY=($(compgen -c -P '\`' -S '\`' -- ${c#?}))	;;
    \$\{*\})	   eval COMPREPLY=\(${c}\) ;;
    \$\{*)		COMPREPLY=($(compgen -v -P '${' -S '}'  -- ${c#??}))	;;
    \$*)		COMPREPLY=($(compgen -v -P '$'		-- ${c#?}))	;;
    \~*/*)		COMPREPLY=($(compgen -f -X "$e" +o plusdirs -- ${c}))	;;
    \~*)		COMPREPLY=($(compgen -u ${s}	 	-- ${c}))	;;
    *@*)		COMPREPLY=($(compgen -A hostname -P '@' -S ':' -- ${c#*@})) ;;
    *[*?[]*)		COMPREPLY=()			# use bashdefault
			((glob == 0)) && shopt -u extglob
			return 0						;;
    *[?*+\!@]\(*\)*)
	if ((glob == 0)) ; then
			COMPREPLY=($(compgen -f -X "$e" -- $c))
			((glob == 0)) && shopt -u extglob
			return 0
	fi
			COMPREPLY=($(compgen -G "${c}"))			;;
    *)
	if test "$c" = ".." ; then
			COMPREPLY=($(compgen -d -X "$e" ${_nosp} +o plusdirs -- $c))
	else
			COMPREPLY=($(compgen -f -X "$e" +o plusdirs -- $c))
	fi
    esac

    if test -n "$t" ; then
	let o=0
	local -a reply=()
 	((quoted)) || _compreply_
	for s in ${COMPREPLY[@]}; do
	    e=$(eval echo $s)
	    if test -d "$e" ; then
		reply[$((o++))]="$s"
		continue
	    fi
	    case "$(file -b $e 2> /dev/null)" in
	    $t)	reply[$((o++))]="$s"
	    esac
	done
	COMPREPLY=(${reply[@]})
	((glob == 0)) && shopt -u extglob
	return 0
    fi

    ((quoted)) || _compreply_

    ((glob == 0)) && shopt -u extglob
    return 0
}

_gdb_ ()
{
    local c=${COMP_WORDS[COMP_CWORD]}
    local e p
    local -i o
    local IFS
    local -i quoted=0

    if [[ "${c:0:1}" == '"' ]] ; then
	let quoted++
	compopt -o plusdirs
    fi

    if test $COMP_CWORD -eq 1 ; then
	case "$c" in
 	-*) COMPREPLY=($(compgen -W '-args -tty -s -e -se -c -x -d' -- "$c")) ;;
	*)  COMPREPLY=($(compgen -c -- "$c"))
	esac
	return 0
    fi

    p=${COMP_WORDS[COMP_CWORD-1]}
    IFS=$'\n'
    case "$p" in
    -args)	COMPREPLY=($(compgen -c -- "$c")) ;;
    -tty)	COMPREPLY=(/dev/tty* /dev/pts/*)
		COMPREPLY=($(compgen -W "${COMPREPLY[*]}" -- "$c")) ;;
    -s|e|-se)	COMPREPLY=($(compgen -f -- "$c")) ;;
    -c|-x)	COMPREPLY=($(compgen -f -- "$c")) ;;
    -d)		COMPREPLY=($(compgen -d ${_nosp} +o plusdirs -- "$c")) ;;
    *)
		if test -z "$c"; then
		    COMPREPLY=($(command ps axho comm,pid |\
				 command sed -rn "\@^${p##*/}@{ s@.*[[:blank:]]+@@p; }"))
		else
		    COMPREPLY=()
		fi
		let o=${#COMPREPLY[*]}
		((quoted)) || _compreply_
		for s in $(compgen -f -- "$c") ; do
		    e=$(eval echo $s)
		    if test -d "$e" ; then
			COMPREPLY[$((o++))]="$s"	
			continue
		    fi
		    case "$(file -b $e 2> /dev/null)" in
		    *)	COMPREPLY[$((o++))]="$s"
		    esac
		done
    esac 
    return 0
}

complete ${_def} -X '.[^./]*' -F _exp_ ${_file} \
				 	compress \
					bzip2 \
					bunzip2 \
					gzip \
					gunzip \
					uncompress \
					unzip \
					gs ghostview \
					gv kghostview \
					acroread xpdf kpdf \
					evince rpm zypper \
					dvips xdvi kdvi \
					tex latex pdflatex

complete ${_def} -F _exp_ ${_file} 	chown chgrp chmod chattr ln
complete ${_def} -F _exp_ ${_file} 	more cat less strip grep vi ed

complete ${_def} -A function -A alias -A command -A builtin \
					type
complete ${_def} -A function		function
complete ${_def} -A alias		alias unalias
complete ${_def} -A variable		unset local readonly
complete ${_def} -F _exp_ ${_nosp}	export
complete ${_def} -A variable -A export	unset
complete ${_def} -A shopt		shopt
complete ${_def} -A setopt		set
complete ${_def} -A helptopic		help
complete ${_def} -A user		talk su login sux
complete ${_def} -A builtin		builtin
complete ${_def} -A export		printenv
complete ${_def} -A command		command which nohup exec nice eval 
complete ${_def} -A command		ltrace strace
complete ${_def} -F _gdb_ ${_file}  	gdb
HOSTFILE=""
test -s $HOME/.hosts && HOSTFILE=$HOME/.hosts
complete ${_def} -A hostname		ping telnet slogin rlogin \
					traceroute nslookup
complete ${_def} -A hostname -A directory -A file \
					rsh ssh scp
complete ${_def} -A stopped -P '%'	bg
complete ${_def} -A job -P '%'		fg jobs disown

# Expanding shell function for manual pager
_man_ ()
{
    local c=${COMP_WORDS[COMP_CWORD]}
    local o=${COMP_WORDS[COMP_CWORD-1]}
    local os="- f k P S t l"
    local ol="whatis apropos pager sections troff local-file"
    local m s

    if test -n "$MANPATH" ; then
	m=${MANPATH//:/\/man,}
    else
	m="/usr/X11R6/man/man,/usr/openwin/man/man,/usr/share/man/man"
    fi

    case "$c" in
 	 -) COMPREPLY=($os)	;;
	--) COMPREPLY=($ol) 	;;
 	-?) COMPREPLY=($c)	;;
	\./*)
	    COMPREPLY=($(compgen -f -d -X '\./.*' +o plusdirs  -- $c)) ;;
    [0-9n]|[0-9n]p)
	    COMPREPLY=($c)	;;
	 *)
	case "$o" in
	    -l|--local-file)
		COMPREPLY=($(compgen -f -d -X '.*' +o plusdirs -- $c)) ;;
	[0-9n]|[0-9n]p)
		s=$(eval echo {${m}}$o/)
		if type -p sed &> /dev/null ; then
		    COMPREPLY=(\
			$(command ls -1UA $s 2>/dev/null|\
			  command sed -rn "/^$c/{s@\.[0-9n].*\.gz@@g;s@.*/:@@g;p;}")\
		    )
		else
		    s=($(ls -1fUA $s 2>/dev/null))
		    s=(${s[@]%%.[0-9n]*})
		    s=(${s[@]#*/:})
		    for m in ${s[@]} ; do
			case "$m" in
			    $c*) COMPREPLY=(${COMPREPLY[@]} $m)
			esac
		    done
		    unset m s
		    COMPREPLY=(${COMPREPLY[@]%%.[0-9n]*})
		    COMPREPLY=(${COMPREPLY[@]#*/:})
		fi					   ;;
	     *) COMPREPLY=($(compgen -c -- $c))		   ;;
	esac
    esac
}

complete ${_def} -F _man_ ${_file}		man

_rootpath_ ()
{
    local c=${COMP_WORDS[COMP_CWORD]}
    local os="-h -K -k -L -l -V -v -b -E -H -P -S -i -s"
    local ox="-r -p -t -u"
    case "$c" in
	-*) COMPREPLY=($(compgen -W "$os $ox" -- "$c")) ;;
	*)  if ((COMP_CWORD <= 1)) ; then
		COMPREPLY=($(PATH=/sbin:/usr/sbin:$PATH:/usr/local/sbin compgen -c -- "${c}"))
	    else
		COMPREPLY=()
	    fi
    esac
    if ((${#COMPREPLY[@]} > 0)) ; then
	let o=0
	for s in ${COMPREPLY[@]}; do
	    e=$(eval echo $s)
	    if test -d "$e" ; then
		compopt -o plusdirs
		break
	    fi
	    if ! type -p "$e" > /dev/null 2>&1 ; then
		COMPREPLY[$o]=$(PATH=/sbin:/usr/sbin:$PATH:/usr/local/sbin type -p "$e" 2> /dev/null)
	    fi
	    let o++
	done
    fi
}

complete ${_def} -F _rootpath_			sudo

_ls_ ()
{
    local c=${COMP_WORDS[COMP_CWORD]}
    local IFS=$'\n'
    local s x
    local -i glob=0
    local -i isdir=0
    local -i quoted=0
    local -i variable=0

    if [[ "${c:0:1}" == '"' ]] ; then
	let quoted++
	compopt -o plusdirs
    fi
    if [[ "${c:0:1}" == '$' ]] ; then
	let variable++
	compopt -o dirnames +o filenames
    else
	compopt +o dirnames -o filenames
    fi

    if test -d "$c" ; then
	compopt -o nospace
    else
	compopt +o nospace
    fi

    shopt -q extglob && let glob++
    ((glob == 0)) && shopt -s extglob

    case "$c" in
    *[*?[]*)	COMPREPLY=()				# use bashdefault
		((glob == 0)) && shopt -u extglob
		return 0						;;
    \$\(*\))    eval COMPREPLY=\(${c}\)
		compopt +o plusdirs					;;
    \$\(*)	COMPREPLY=($(compgen -c -P '$(' -S ')'  -- ${c#??}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \`*\`)	eval COMPREPLY=\(${c}\)
		compopt +o plusdirs					;;
    \`*)	COMPREPLY=($(compgen -c -P '\`' -S '\`' -- ${c#?}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \$\{*\})	eval COMPREPLY=\(${c}\)					;;
    \$\{*)	COMPREPLY=($(compgen -v -P '${' -S '}'  -- ${c#??}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    if ((${#COMPREPLY[@]} > 1)) ; then
			((glob == 0)) && shopt -u extglob
			return 0
		    fi
		    let isdir++
		    eval COMPREPLY=\(${COMPREPLY[@]}\)
		fi							;;
    \$*)	COMPREPLY=($(compgen -v -P '$' $s	-- ${c#?}))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    if ((${#COMPREPLY[@]} > 1)) ; then
			((glob == 0)) && shopt -u extglob
			return 0
		    fi
		    let isdir++
		    eval COMPREPLY=\(${COMPREPLY[@]}\)
		fi							;;
    \~*/*)	COMPREPLY=($(compgen -d $s +o plusdirs  -- "${c}"))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    \~*)	COMPREPLY=($(compgen -u $s		-- "${c}"))
		if ((${#COMPREPLY[@]} > 0)) ; then
		    compopt +o plusdirs
		    let isdir++
		fi							;;
    *\:*)	if [[ $COMP_WORDBREAKS =~ : ]] ; then
		    x=${c%"${c##*[^\\]:}"}
		    COMPREPLY=($(compgen -d $s +o plusdirs -- "${c}"))
		    COMPREPLY=(${COMPREPLY[@]#"$x"})
		    ((${#COMPREPLY[@]} == 0)) || let isdir++
		fi
		((glob == 0)) && shopt -u extglob
		return 0						;;
    *)		COMPREPLY=()			    # use (bash)default
		((glob == 0)) && shopt -u extglob
		return 0						;;
    esac

    ((quoted)) || _compreply_ $isdir

    ((glob == 0)) && shopt -u extglob
}

complete ${_def} ${_file}  -F _ls_		ls ll la l ls-l lf

unset _def _dir _file _nosp

#
# info bash 'Command Line Editing' 'Programmable Completion'
#
if ! type -t _completion_loader &> /dev/null ; then
    _completion_loader ()
    {
	local fallback=(-o default -o bashdefault -o filenames)
	local dir=/usr/share/bash-completion/completions
	local cmd="${1##*/}"
	. "${dir}/${cmd}" &>/dev/null && return 124
	complete "${fallback[@]}" ${cmd} &>/dev/null && return 124
    }
    complete -D -F _completion_loader
fi

#
# End of /etc/profile.d/complete.bash
#
