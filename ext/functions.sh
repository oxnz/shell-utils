# ~/.shell/functions.sh
# utility functions
: << =cut
=pod

=encoding UTF-8

=head1 NAME

B<functions.sh> - common shell functions for sh compatible shell(s)

=head1 DESCRIPTION

This file contains some common functions to extend the original shell. The
documentation can be shown with C<perldoc functions.sh> or converted to manual
page with C<pod2man>.

=head1 FUNCTIONS
=cut
################################################################################
: << =cut
=head2 log

a simple logger
=cut
# Constants: LOGFILE
################################################################################
function log() {
    local -r LOGFILE="${SHELL_UTILS_HOME}/var/log/shell.log"
    echo "[$(date '+%F %T %Z') $(pwd) ${FUNCNAME[1]}] $@" >> "$LOGFILE"
}

################################################################################
# query weather info
# ref: http://openweathermap.org/current
# TODO: use ip2loc get location, then get weather by coord
################################################################################
function weather() {
    if [ $# -ne 1 ]; then
        echo "Usage: ${FUNCNAME[0]} [option] <city>" >&2
        return 1
    fi
    local -r city="$1"
    local -r baseurl='http://api.openweathermap.org/data/2.5/weather'
    local -r url="${baseurl}?q=${city:-Wuhan},${country:-cn}&units=${units:-metric}"
    ruby -e '
require "net/http"
require "json"

fmtime = lambda { |ts| Time.at(ts).strftime("%F %T %Z") }
res = Net::HTTP.get_response(URI('"'${url}'"'))
if res.is_a?(Net::HTTPSuccess)
    res = JSON.parse(res.body)
    printf <<EOF
Name: #{res["name"]}(#{res["sys"]["country"]}) coord(lon: #{res["coord"]["lon"]}, lat: #{res["coord"]["lat"]})
Sunrise: #{fmtime.call(res["sys"]["sunrise"])}, Sunset: #{fmtime.call(res["sys"]["sunset"])}
Weather:
EOF
res["weather"].each {|w|
    printf %Q/\tmain: #{w["main"]}, description: #{w["description"]}\n/
}
printf <<EOF
Temp: #{res["main"]["temp"]}(min: #{res["main"]["temp_min"]}, max: #{res["main"]["temp_max"]}), pressure: #{res["main"]["pressure"]}, humidity: #{res["main"]["humidity"]}
Wind: #{res["wind"]["speed"]} m/s, deg: #{res["wind"]["deg"]}
Clouds: #{res["clouds"]["all"]}
EOF
end
'
}

################################################################################
# convert ip address to location info
: << =cut
=head2 ip2loc

convert ip address to location info
=cut
################################################################################
function ip2loc() {
    local opt
    local OPTIND=1
    while getopts "hv" opt; do
        case "$opt" in
            h)
                echo "Usage: ${FUNCNAME[0]} [option] [ip]"
                return
                ;;
            v)
                local -r verbose='true'
                ;;
            ?)
                ip2loc >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local ip="$1"
    local scpt='/^.$/d;s/^\s*"\([^"]*\)":\s*"\([^"]*\)",\?$/\1: \2/'
    if [ -n "$verbose" ]; then
        curl ipinfo.io/"${ip}" > >(sed -e "$scpt")
    else
        curl ipinfo.io/"${ip}" > >(sed -e "$scpt") 2>/dev/null
    fi
}

################################################################################
# test if variable is specified type
: << =cut
=head2 isnum

test if variable is specified type
=cut
################################################################################
function isnum() {
    local opt
    local OPTIND=1
    while getopts ":hf:q" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] [variable]
    Options:
        -f  format:
            -d  decimal number
            -o  octal number
            -x  hex number
            if not specified, any matched format will return true
        -h  show this message and exit
        -q  quiet
End-Of-Usage
                return
                ;;
            f)
                case "$OPTARG" in
                    d)
                        local -r fmt=d
                        local -r pattern='^[0-9]$|^[1-9][0-9]*$'
                        ;;
                    o)
                        local -r fmt=o
                        local -r pattern='^[0-7]$|^0[0-7]*$'
                        ;;
                    x)
                        local -r fmt=x
                        local -r pattern='^0$|^0[xX][0-9a-fA-F]*$'
                        ;;
                    *)
                        echo "Unrecognized format '$OPTARG' for option 'f'" >&2
                        return 1
                        ;;
                esac
                ;;
            q) local -r quiet='true' ;;
            :)
                echo "${FUNCNAME[0]}: option requires an argument -- $OPTARG" >&2
                return 1
                ;;
            ?)
                [[ "$OPTARG" =~ [0-9] ]] && break
                echo "${FUNCNAME[0]}: illegal option -- $OPTARG" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local s="$1"
    if [ $# -ne 1 -o -z "$s" ]; then
        [ "$quiet" == 'true' ] || isnum -h >&2
        return 1
    fi
    case "${fmt:-any}" in
        o|d|x)
            case "${s:0:1}" in -|+) s="${s:1}" ;; esac
            [[ "$s" =~ $pattern ]] && return 0
            ;;
        'any')
            printf '%d' "$s" >& /dev/null && return 0
            ;;
        *)
            echo "Unsupported format '${fmt}'" >&2
            ;;
    esac
    return 1
}

################################################################################
# generate random stuff
################################################################################
function random() {
    local opt
    local OPTIND=1
    while getopts 'hl:' opt; do
        case "$opt" in
            h)
                echo "Usage: ${FUNCNAME[0]} [option] [string]"
                return
                ;;
            l)
                local -i len=$((OPTARG))
                if [ $len -eq 0 ]; then
                    echo "${FUNCNAME[0]}: Invalid argument: '${OPTARG}' for option: '-l'" >&2
                    return 1
                fi
                ;;
        esac
    done
    shift $((OPTIND-1))

    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${len:-16} | xargs
}

##############################################################################
# godoc use less
##############################################################################
function godoc() {
    command godoc "$@" | less
}

##############################################################################
# fortune
: << =cut
=head2 fortune

the classic fortune alternative
=cut
##############################################################################
function fortune() {
    local f="${HOME}/.shell/data/fortune"
    local nline
    nline=$(wc -l "$f")
    nline="${nline// *}"
    if [ $nline -le 0 ]; then
        echo "Misfortune: file has line count: ${nline}" >&2
        return 1
    fi
    local index
    index=$((RANDOM % nline))
    sed -ne "${index}{p;q}" "$f"
}

##############################################################################
# convert human-readable data(and time) to seconds since epoch and vice versa
##############################################################################
function epoch() {
:
}

############################################################
: << =cut
=head2 confirm

used to get user answer interactivly
=cut
# Options:
############################################################
function confirm() {
    local -a args="${@}"
    local opt
    local OPTIND=1
    while getopts "d:hp:t:T:" opt; do
        case "$opt" in
            d)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i default="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 'd'" >&2
                    return 1
                fi
                ;;
            h)
                cat <<End-Of-Help
Usage: ${FUNCNAME[0]} [option]
    options:
        -d valued returned when Enter pressed, default 0
        -h print help message and exit
        -p prompt
        -t timeout, default is 3
        -T value returned when timeout, defalut is read errcode
End-Of-Help
                return
                ;;
            p)
                if [ -n "$OPTARG" ]; then
                    prompt="${OPTARG}, are you sure ?"
                else
                    echo "Invalid prompt '${OPTARG}' for option 'p'" >&2
                    return 1
                fi
                ;;
            t)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i timeout="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 't'" >&2
                    return 1
                fi
                ;;
            T)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i tmodef="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 'T'" >&2
                    return 1
                fi
                ;;
            ?)
                confirm -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local reply
    read -n 1 -p "${prompt:-Are you sure ?} [y/n]: " -t "${timeout:-3}" -r reply
    local -i retval=$?
    # timeout or Ctrl-C
    if [ $retval -ne 0 ]; then
        if [ $retval -gt 128 ]; then
            echo "timeout"
            return ${tmodef:-$retval}
        else
            echo "failed"
            return $retval
        fi
    fi
    local emsg=''
    case "${reply:-enter}" in
        enter)
            emsg='default'
            retval=${default:-0}
            ;;
        y|Y) retval=0 ;;
        $'\x04'|n|N) retval=1 ;;
        *)
            echo "Invalid input: '${reply}'" >&2
            confirm "$args"
            return
            ;;
    esac
    echo "$emsg"
    return $retval
}

################################################################################
# initialize the utilities, define some useful hook(s)
# trap signal(s)
################################################################################
function __initialize__() {
    if ! typeset -f command_not_found_handle > /dev/null; then
        function command_not_found_handle() {
            echo "${SHELL:-bash}: $1: command not found"
        }
        declare command_not_found_handle=command_not_found_handle
        #declare -g command_not_found_handle=command_not_found_handle
    fi

    # test if function to declare already exists
    local func
    for func in man words ips extract histop itunes; do
        if typeset -f $func > /dev/null; then
            echo "WARNING: ${func} is aleary exists"
        fi
    done

    # set trap to intercept the non-zero return code of last program
    function _err() {
        local ecode=$?
        local cmd
        cmd="$(history | tail -1 | sed -e 's/^ *[0-9]* *//')"
        log "command: [${cmd}] exit code: [${ecode}]"
    }
    trap _err ERR

    # do some stuff before exit
    function _exit() {
        log "${USER} leaves $(tty)"
    }
    trap _exit EXIT
}
__initialize__
unset __initialize__

: << =cut
=head2 man

colorized man
=cut
function man () {
	env \
	LESS_TERMCAP_mb=$'\E[01;31m' \
	LESS_TERMCAP_md=$'\E[01;34m' \
	LESS_TERMCAP_me=$'\E[00m' \
	LESS_TERMCAP_se=$'\E[00m' \
	LESS_TERMCAP_so=$'\E[1;44;33m' \
	LESS_TERMCAP_ue=$'\E[00m' \
	LESS_TERMCAP_us=$'\E[01;32m' \
	man "$@"
    local -r ret=$?
    : $'\E[0m' # end the color attr in `readonly -pf`
    return $ret
}

#########################################
: << =cut
=head2 words

look up similar word(s) in *nix's dict
=cut
#########################################
function words() {
    local word
    for word; do
        grep "$word" /usr/share/dict/words
    done
}

################################################################################
: << =cut
=head2 ips

show ip addr and scope, etc about every NIC found

# depends on binary ip
# hostname --all-ip-address (man 1 hostname)
=cut
################################################################################
case "$(uname -s)" in
	Linux)
function ips() {
    ip -family inet -oneline address show | perl -ne '
    {
        my @recs;
        sub addrec { push @recs, \@_; }
        sub fmtout {
            my $fmt = "%-8s%-8s%-20s%-16s%-s\n";
            foreach (@recs) { printf($fmt, @$_); }
        }
    }

    BEGIN { &addrec("Index", "Device", "IPv4 Address", "Broadcast", "Scope"); }

    { #sub main
        if (my ($index, $dev, $inet, $brd, $scope, $flags) = /^(\d+):\s+(\w+)\s+inet\s+([^\s]+)(?:\s+brd\s+([^\s]+)|)\s+scope\s+([^\\]+)\\\s+(.*)$/) {
            &addrec($index, $dev, $inet, defined($brd) ? $brd : " ", $scope);
        }
    }

    END { &fmtout(); }'
}
;;
	Darwin)
		function ips() {
			ifconfig | awk '/inet / { print $2 }'
		}
		;;
esac
################################################################################
: << =cut
=head2 extract

extract file(s) from compressed status
=cut
# Parameter(s):
#   compressed files
################################################################################
function extract() {
    local opt
    local OPTIND=1
    while getopts "hv" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] <archives>
    options:
        -h  show this message and exit
        -v  verbosely list files processed
End-Of-Usage
                return
                ;;
            v)
                local -r verbose='v'
                ;;
            ?)
                extract -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $# -eq 0 ] && extract -h && return 1
    while [ $# -gt 0 ]; do
	    if [ -f "$1" ]; then
		    case "$1" in
                *.tar.bz2|*.tbz|*.tbz2) tar "x${verbose}jf" "$1" ;;
                *.tar.gz|*.tgz) tar "x${verbose}zf" "$1" ;;
                *.tar.xz) xz --decompress "$1"; set -- "$@" "${1:0:-3}" ;;
                *.tar.Z) uncompress "$1"; set -- "$@" "${1:0:-2}" ;;
                *.bz2) bunzip2 "$1" ;;
                *.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
                *.pax.gz) gunzip "$1"; set -- "$@" "${1:0:-3}" ;;
                *.gz) gunzip "$1" ;;
                *.pax) pax -r -f "$1" ;;
                *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
                *.rar) unrar x "$1" ;;
                *.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
                *.tar) tar "x${verbose}f" "$1" ;;
                *.txz) mv "$1" "${1:0:-4}.tar.xz"; set -- "$@" "${1:0:-4}.tar.xz" ;;
                *.xz) xz --decompress "$1" ;;
                *.zip|*.war|*.jar) unzip "$1" ;;
                *.Z) uncompress "$1" ;;
                *.7z) 7za x "$1" ;;
                *) echo "'$1' cannot be extracted via extract" >&2;;
		    esac
        else
		    echo "extract: '$1' is not a valid file" >&2
	    fi
        shift
    done
}

if [ -n "$BASH_VERSION" ]; then
    :
elif [ -n "$ZSH_VERSOIN" ]; then
    compdef '_files -g "*.gz *.tgz *.txz *.xz *.7z *.Z *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract
fi

################################################################################
# find a pattern in a set of files and highlight them
# see http://tldp.org/LDP/abs/html/sample-bashrc.html
################################################################################
function fs() {
    local opt
    local OPTIND=1
    while getopts "d:Ef:hI" opt; do
        case "$opt" in
            d)
                if [ -d "$OPTARG" ]; then
                    local -r dir="$OPTARG"
                else
                    echo "${FUNCNAME[0]}: Invalid direcotry -- $OPTARG" >&2
                    return 1
                fi
                ;;
            E)
                which egrep > /dev/null && local -r grep="egrep" ||
                    echo "${FUNCNAME[0]}: egrep not found, fallback to grep" >&2
                ;;
            f)
                local -r fpat="$OPTARG"
                ;;
            h)
                cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] <pattern(s)>
    options:
        -d  <search directory>
        -E  use egrep
        -f  <filename pattern>
        -h  show this message and exit
        -I  case-insensitive
End-Of-Usage
                return
                ;;
            I)
                local -r case="-i"
                ;;
            ?)
                fs -h >&2
                return 1
        esac
    done
    shift $((OPTIND-1))

    if [ "$#" -eq 0 ]; then
        echo "${FUNCNAME[0]}: pattern string misssing" >&2
        return 1
    fi

    local pat
    for pat; do
        shift
        set -- "$@" "-e" "$pat"
    done
    find "${dir:-.}" -type f -name "${fpat:-*}" -exec "${grep:-grep}" --color=auto -H -n ${case} "$@" {} \;
}

################################################################################
# find file
################################################################################
function ff() {
    find . -type f -name "$@"
}

################################################################################
# Description:
#	History accepts a range in zsh entries as [first] [last] arguments, so to
#	get them all run history 1.
#	Note that the history list starts at 1 and not 0
#	print top command in history
# Globals:
#	None
# Arguments:
#	-h|-n <num>
# Returns:
#	None
################################################################################
function histop() {
    local opt
    local OPTIND=1
    while getopts "hn:" opt; do
        case "$opt" in
            h)
				cat <<-End-Of-Help
Usage: histop -n <num>
    num: print num lines of most used command
End-Of-Help
                return
                ;;
            n)
                local -i n=$((OPTARG))
                if [ $n -eq 0 ]; then
                    echo "${FUNCNAME[0]}: Invalid argument: '${OPTARG}' for option: '-n'" >&2
                    return 1
                fi
                ;;
            ?)
                histop -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))
	if [ $# -ne 0 ]; then
		echo "${FUNCNAME} Unexpected parameter(s): '$@'"
		return 1
	fi

    fc -n -l $((-${HISTSIZE:-1})) | perl -ane 'BEGIN {my %cmdlist}{$cmdlist{@F[0]}++}
	END {printf("Number\tTimes\tFrequency\tCommand\n");
	my ($i, $cnt) = (0, 0);
	foreach my $cmd (sort {$cmdlist{$b} <=> $cmdlist{$a}} keys %cmdlist) {
        last if ++$i > '"${n:-10}"';
        $cnt += $cmdlist{$cmd};
        printf("%-8d %-8d%6.2f%%\t%-16s\n", $i, $cmdlist{$cmd},
            $cmdlist{$cmd}*100/$., $cmd);
    }
    printf("%-8s%4d/%-4d%8.2f%%\t%-16s\n", "-", $cnt, $., $cnt*100/$., "");
	}'
}

###########################################################
# iTunes control function
# Options:
#   launch|play|pause|stop|rewind|resume
#   quit|mute|unmute|next|previous|help
# Returns:
#	None
###########################################################
function itunes() {
	local opt="$1"
	shift
	case "$opt" in
		launch|play|pause|stop|rewind|resume|quit)
			;;
		mute)
			opt="set mute to true"
			;;
		unmute)
			opt="set mute to false"
			;;
		next|previous)
			opt="$opt track"
			;;
		""|-h|--help)
            cat <<End-Of-Help
Usage: itunes <option>
    option:
        launch|play|pause|stop|rewind|resume|quit
        mute|unmute     control volume set
        next|previous   play next or previous track
        help            show this message and exit
End-Of-Help
			return
			;;
		*)
			print "Unkonwn option: $opt"
			return 1
			;;
	esac
	osascript -e "tell application \"iTunes\" to $opt"
}

################################################################################
# easy use apt-{get,cache}
################################################################################
function apt-() {
    local arg
    for arg; do
        case "$arg" in
            update|upgrade|install|remove|source|build-dep|dist-upgrade|\
                dselect-upgrade|clean|autoclean|check)
                command apt-get "$@"
                return
                ;;
            add|gencaches|showpkg|showsrc|stats|dump|dumpavail|unmet|\
                    search|show|depends|rdepends|pkgnames|dotty|xvcg|policy)
                command apt-cache "$@"
                return
                ;;
            -*) ;; # args
            *)
                echo "unknown command '$@' for apt-{get,cache}" >&2
                return 1
                ;;
        esac
    done
}

################################################################################
# display apt-history
# Options:
#   help|install|upgrade|remove|list
# Returns:
#	None
# Note:
#   \<,\>: word boundary in regular expression
#   ref: http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/special-chars.html
################################################################################
function apt-hist() {
	case "$1" in
		install|upgrade|remove)
            apt-hist list | grep --no-filename "\<$1\>"
			;;
		list)
            for log in $(ls -t /var/log/dpkg.log*); do
                [ -f "$log" ] || continue
                if [ ${log##*.} == gz ]; then
                    gunzip -c $log | tac
                else
                    tac $log
                fi
            done
			;;
		""|-h|--help)
			echo "Usage: apt-hist <help|install|upgrade|remove|rollback|list>"
            ;;
        *)
			print "Unkonwn option: $opt"
            apt-hist --help >&2
            return 1
            ;;
	esac
}

########################################################################
: << =cut
=head2 quote | unquote

perform uri_encode | uri_decode

# perl -MURI::Escape -e 'print uri_unescape();'
# Options:
#   ahp
=cut
########################################################################
function quote() {
    # candidate implementation
    #perl -MURI::Escape -e 'print uri_escape($ARGV[0]), "\n"' "$1"
    local opt
    local OPTIND=1
    while getopts "afFhpu" opt; do
        case "$opt" in
            a)
                local -r a=1
                ;;
            h)
                cat <<End-Of-Help
Usage: quote [option] [string]
    options:
        -a quote all characters
        -h show this help message and exit
        -p path quote
End-Of-Help
                return
                ;;
            p)
                local -r p=\/
                ;;
            ?)
                quote -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local -r s="$1"
    local -r -i l=${#s}
    local t=''
    local c
    local o
    local -i i

    for ((i = 0; i < l; ++i)); do
        c="${s:i:1}"
        case "$c" in
            "$p"|"$a"[-_.~a-zA-Z0-9])
                o="$c"
                ;;
            *)
                o=$(echo -n "$c" | od -An -t x1 | tr '[ a-z]' '[%A-Z]')
                ;;
        esac
        t+="$o"
    done
    echo $t
}

function unquote() {
    printf '%b\n' "${1//%/\\x}" | tr '+' ' '
}

################################################################################
: << =cut
=head2 trash

move file to trash bin. This function is intend to used like C<alias rm='trash'>
to play safer

=over

=item Globals

HOME

=item Options

cdhlr

=item Arguments

file(s)

=item Returns

None

=back
=cut
###########################################################
function trash() {
    local -r TRASHDIR="${HOME}/.local/share/Trash"
    local -r FILEDIR="${TRASHDIR}/files"
    local -r INFODIR="${TRASHDIR}/info"
    local opt
    local OPTIND=1
    while getopts "cd:hlr:" opt; do
        case "$opt" in
            c)
                local prompt='[trash] the clear operation cannot be undone'
                if confirm -p "${prompt}" -t 2 -d 1; then
                    rm -rf {"${FILEDIR}","${INFODIR}"}/*
                else
                    echo "cancelled"
                fi
                return
                ;;
            d)
                echo "delete file '${OPTARG}'"
                return
                ;;
            h)
                echo "Usage: trash [option] [file]"
                return
                ;;
            l)
                echo $'DeletionDate\tDeletionTime\tPath'
                local f
                local item
                for f in "${INFODIR}"/*.trashinfo; do
                    [ -f "$f" ] || continue
                    item="$(sed -ne '2h
                    3{G;s/DeletionDate=\(.*\)T\(.*\)\nPath=\(.*\)/\1\t\2\t\3/p;q}' "$f")"
                    printf '%b\n' "${item//%/\\x}"
                done
                return
                ;;
            r)
                echo "restore ${OPTARG} not supported yet"
                return
                ;;
            ?)
                trash -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local src
    local dst
    local -i i
    for src; do
        dst="${FILEDIR}/${src}"
        if [ -e "${dst}" ]; then
            i=2
            while [ -e "${dst}.$i" ]; do
                i+=1
            done
            dst="${dst}.$i"
        fi
        cat <<EOT > "${INFODIR}/$(basename "${dst}").trashinfo"
[Trash Info]
Path=$(quote -p "$(readlink -e "${src}")")
DeletionDate=$(date "+%FT%T")
EOT
        if ! command mv -- "$src" "$dst"; then
            echo "failed to move file '${src}' to trash" >&2
            return 1
        fi
    done
}

which unix2dos > /dev/null || function unix2dos() {
    [[ "$#" -eq 0 ]] && echo "Usage: unix2dos <file>" ||
    command perl -i -p -e 's/\n/\r\n/' "$1"
	# alternatives:
	#	1. awk 'sub("$", "\r")' unixfile.txt > dosfile.txt
}

which dos2unix > /dev/null || function dos2unix() {
    [[ "$#" -eq 0 ]] && echo "Usage: dos2unix <file>" ||
    command perl -i -p -e 's/\r\n/\n/' "$1"
	# alternatives:
	# 	1. tr -d '\015\032' < dosfile.txt > unixfile.txt
	#	2. awk '{ sub("\r$", ""); print }' dosfile.txt > unixfile.txt
}

which perror > /dev/null || function perror() {
    if [ $# -eq 0 ]; then
        echo "Usage: perror errno"
        return
    fi

    perl -MPOSIX -e 'my ($errno, $errmsg) = ($ARGV[0], "");
    if ($errno ne $errno + 0) {
        die "Invalid errno: [$errno]\n";
    } elsif ($errno == 0) {
        $errmsg = "Success";
    } else {
        $errmsg = strerror($errno);
    }
    printf "error code %3d:\t$errmsg\n", $errno;' "$@"
}

which tree > /dev/null || function tree() {
    local opt
    local OPTIND=1
    while getopts "h" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Help
Usage: tree [option] [directory]
End-Of-Help
                return
                ;;
            ?)
                tree -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [ $# -gt 1 ]; then
        echo "too many parameters" >&2
        return 1
    fi
    local dir="${1:-.}"
    echo "$dir"
    find "$dir" -print | sed -e 's#[^/]*/#|____#g
    s#____|#  |#g'
}
###########################################################
: << =cut
=head2 google

search google via command line

=over

=item Constans:

Google search url prefix

=item Arguments

keyword(s)

=item Result:

open search result(s) in the default browser

=back
=cut
###########################################################
function google() {
    local -r url="https://www.google.com.hk/search?hl=en#newwindow=1&q="
	case "$1" in
		"" | -h | --help)
			echo "Usage: google <keyword>"
			;;
		*)
            local keyword
            for keyword; do
                open "${url}$(quote "$keyword")"
			done
			;;
	esac
}


###########################################################
: << =cut
=head2 digdug

all the info that dig can find
=cut
###########################################################
function digdug() {
    dig +nocmd "$1" any +multiline +noall +answer
}

function man2pdf() {
    if [ $# -ne 2 ]; then
        echo "Usage: ${FUNCNAME[0]} <man> <pdf>" >&2
        return
    fi
    man -t "$1" | ps2pdf - "$2"
}

function todo() {
    echo "see https://docs.python.org/3.2/library/dbm.html"
    cat <<End-Of-Usage
    "TODO: dbm"
    echo "Usage: todo <-l|-d|-c|-t|-n>"
    -l list
    -d delete
    -n create
    -c content
    -t title
End-Of-Usage
}

###########################################################
: << =cut
=head2 vardump

dump var after tidle expand, command substitute, etc.
=cut
###########################################################
function vardump() {
	local -i i=0
    local arg
	for arg; do
        i+=1
		echo "\$${i} => $arg"
		shift;
	done
}

# TODO: add apply, map, filter, reduce function
function apply() {
    if [ $# -ne 2 ]; then
        echo "Usage: apply input-cmd process-cmd" >&2
        return 1
    fi

    local item
    for item in $($1); do
        $2 "$item"
    done
}

function filter() {
    if [ $# -ne 2 ]; then
        echo "Usage: filter input-cmd filter-cmd" >&2
        return 1
    fi

    local item
    for item in $($1); do
        if $2 "$item"; then
            echo "$item"
        fi
    done
}

function __finalize__() {
    for func in man words ips extract histop itunes; do
        readonly -f $func > /dev/null
    done
}
__finalize__
unset __finalize__

: << =cut
=head1 LICENSE

MIT

=head1 AUTHOR

L<yunxinyi@gmail.com>

Copyright (c) 2011-2014 Oxnz, All rights reserved.

=cut
# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
