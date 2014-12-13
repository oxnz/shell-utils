
# Add paths for the krb5 package
if ( -d /usr/lib/mit/bin ) then
    set COUNT=`ls -1 /usr/lib/mit/bin/ | wc -l`
    if ( $COUNT > 0 ) then
        setenv PATH "${PATH}:/usr/lib/mit/bin"
    endif
endif
if ( -d /usr/lib/mit/sbin ) then
    set COUNT=`ls -1 /usr/lib/mit/sbin/ | wc -l`
    if ( $COUNT > 0 ) then
        setenv PATH "${PATH}:/usr/lib/mit/sbin"
    endif
endif

