# uniquefy_search_path (search_path):
#
# Remove duplicate entries from a search path string, preserving order.
uniquefy_search_path ()
{
  OIFS="$IFS"
  IFS='
'
  set -- $(echo ${1+"$@"} | sed -r 's@/*:|([^\\]):@\1\n@g;H;x;s@/\n@\n@')
  IFS="$OIFS"

  _y=""
  for _x ; do
    case ":${_y}:" in
      *:"${_x}":*) continue
    esac
    _y=${_y:+"$_y:"}${_x}
  done

  echo "${_y}"
  unset _y _x
}

for xdgdir in /usr/local/share /usr/share /etc/opt/*/share /opt/*/share /usr/share/gnome ; do
   if test -d "$xdgdir" && test -d "$xdgdir/applications"; then
      if test -z "$XDG_DATA_DIRS"; then
         XDG_DATA_DIRS="$xdgdir"
      else
         XDG_DATA_DIRS="$XDG_DATA_DIRS:$xdgdir"
      fi
   fi
done

XDG_DATA_DIRS=$(uniquefy_search_path "$XDG_DATA_DIRS")
export XDG_DATA_DIRS

for xdgdir in /usr/local/etc/xdg /etc/xdg /etc/opt/*/xdg ; do
   if test -d "$xdgdir"; then
      if test -z "$XDG_CONFIG_DIRS"; then
         XDG_CONFIG_DIRS="$xdgdir"
      else
         XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:$xdgdir"
      fi
   fi
done

XDG_CONFIG_DIRS=$(uniquefy_search_path "$XDG_CONFIG_DIRS")
export XDG_CONFIG_DIRS

unset xdgdir
